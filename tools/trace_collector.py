#!/usr/bin/env python3

import asyncio
import os
import re
import sys
import traceback

from datetime import datetime
from signal import SIGINT, SIGTERM
from typing import List

import aiofiles
import serial_asyncio

from pynrfjprog import HighLevel
from pynrfjprog.HighLevel import ComPortInfo, DeviceFamily


class Devkit:
    def __init__(self):
        self.seid = None
        self.ip = None
        self.ports = {}
        self.ts = ""
        self.snr = 0

        self.debug = None
        self.debug_path = ""
        self.debug_closer = None
        self.debug_file = None

        self.trace = None
        self.trace_path = ""
        self.trace_closer = None
        self.trace_file = None

    @classmethod
    async def new(cls, snr, ports: List[ComPortInfo]):
        self = Devkit()
        for p in ports:
            if p.vcom == 0:
                self.ports["debug"] = p.path
                (
                    self.debug,
                    self.debug_closer,
                ) = await serial_asyncio.open_serial_connection(
                    url=p.path, baudrate=115200
                )
            if p.vcom == 2:
                self.ports["trace"] = p.path
                (
                    self.trace,
                    self.trace_closer,
                ) = await serial_asyncio.open_serial_connection(
                    url=p.path, baudrate=1_000_000, timeout=0
                )

        self.ts = datetime.now().strftime("%Y-%m-%dT%H-%M-%SZ")
        self.snr = snr
        self.debug_path = f"debug-{snr}.txt"
        self.trace_path = f"trace-{snr}.bin"
        self.debug_file = await aiofiles.open(self.debug_path, "w", buffering=1)
        self.trace_file = await aiofiles.open(self.trace_path, "wb", buffering=0)
        return self

    def __del__(self):
        if self.seid:
            os.rename(self.debug_path, f"debug-{self.seid}-{self.ts}.txt")
            os.rename(self.trace_path, f"trace-{self.seid}-{self.ts}.bin")

    async def handle_debug(self):
        while True:
            line = await self.debug.readline()
            await self.debug_file.write(line.decode())

            seid_search = b"SEID: "
            ip_search = b"IP: "

            if self.seid is None:
                pos = line.find(seid_search)
                if pos != -1:
                    pos += len(seid_search)
                    # use regex to remove ascii chars at the end
                    self.seid = (
                        re.search(
                            "[0-9a-fA-F]{19,20}", line[pos:].decode().strip()
                        ).group(0)
                        or ""
                    )
                    print(f"associating {list(self.ports.values())} to {self.seid}")

            if self.ip is None and self.seid is not None:
                pos = line.find(ip_search)
                if pos != -1:
                    pos += len(ip_search)
                    # use regex to remove ascii chars at the end
                    self.ip = (
                        re.search(
                            "([0-9]{1,3}\\.*){4}", line[pos:].decode().strip()
                        ).group(0)
                        or ""
                    )
                    print(f"associating {self.seid} to {self.ip}")

    async def handle_trace(self):
        while True:
            data = await self.trace.read(n=4)
            await self.trace_file.write(data)


async def main():
    dk = []

    with HighLevel.API() as api:
        print(api.get_connected_probes())
        for p in api.get_connected_probes():
            try:
                with HighLevel.DebugProbe(api, p) as probe:
                    if probe.get_device_info().device_family == DeviceFamily.NRF91:
                        probe_inf = probe.get_probe_info()
                        dk.append(
                            await Devkit.new(
                                probe_inf.serial_number, probe_inf.com_ports
                            )
                        )
                    probe.reset()
            except Exception:
                traceback.print_exc()

    if not dk:
        sys.exit("found no NRF9160DKs")

    try:
        await asyncio.gather(
            *[d.handle_trace() for d in dk], *[d.handle_debug() for d in dk]
        )
    except asyncio.CancelledError:
        pass

    for d in dk:
        await d.trace_file.close()
        await d.debug_file.close()


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    fut = asyncio.ensure_future(main())

    for sig in [SIGINT, SIGTERM]:
        loop.add_signal_handler(sig, fut.cancel)

    try:
        loop.run_until_complete(fut)
    finally:
        loop.close()

    print("goodbye!")
