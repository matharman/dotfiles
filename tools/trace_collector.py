#!/usr/bin/env python3

import os
import serial
import sys
import time
import traceback

from datetime import datetime
from pynrfjprog import LowLevel


class Devkit:
    def __init__(self, snr: int, com):
        debug_vcom = 0
        trace_vcom = 2

        self.search = "SEID: "
        self.iccid = ""
        self.ip = ""
        self.ts = datetime.now().strftime("%Y-%m-%dT%H-%M-%SZ")
        self.snr = snr
        self.debug_port = next(c.path for c in com if c.vcom == debug_vcom)
        print(f"SNR {self.snr} debug on {self.debug_port}")
        self.debug_port = serial.Serial(self.debug_port, baudrate=115200)
        self.debug_file = open("debug-{}.txt".format(self.snr), "w", buffering=1)

        self.trace_port = next(c.path for c in com if c.vcom == trace_vcom)
        print(f"SNR {self.snr} trace on {self.trace_port}")
        self.trace_port = serial.Serial(self.trace_port, baudrate=1_000_000, timeout=0)
        self.trace_file = open("trace-{}.bin".format(self.snr), "wb")

        self.handle_debug = self._handle_debug_search

    def __del__(self):
        debug_path = self.debug_file.name
        trace_path = self.trace_file.name

        self.debug_file.close()
        self.trace_file.close()

        os.rename(debug_path, f"debug-{self.iccid}-{self.ts}.txt")
        os.rename(trace_path, f"trace-{self.iccid}-{self.ts}.bin")

    def _handle_debug_search(self):
        data = self.debug_port.readline()
        if data:
            data = data.decode()
            pos = data.find(self.search)
            if pos != -1:
                self.timeout = 0
                start = pos + len(self.search)
                if "SEID" in self.search:
                    self.iccid = data[start : start + 20]
                    print(f"associating {self.snr} to {self.iccid}")
                    self.search = "IP: "
                elif "IP" in self.search:
                    self.ip = data[start:-1]
                    print(f"associating {self.iccid} to {self.ip}")
                    self.handle_debug = self._handle_debug_have_params
                    self.debug_port.timeout = 0

            self.debug_file.write(data)

    def _handle_debug_have_params(self):
        data = self.debug_port.read_all()
        if data:
            self.debug_file.write(data.decode())

    def handle_trace(self):
        data = self.trace_port.read_all()
        if data:
            self.trace_file.write(data)

    def handle_data(self):
        self.handle_trace()
        self.handle_debug()


if __name__ == "__main__":
    api = LowLevel.API()
    api.open()

    dk = []
    for s in api.enum_emu_snr():
        try:
            api.connect_to_emu_with_snr(s)
            api.halt()

            (_, name, _, _) = api.read_device_info()
            if name == LowLevel.DeviceName.NRF9160:
                dk.append(Devkit(s, api.enum_emu_com_ports(s)))
                api.sys_reset()
                api.go()
            api.disconnect_from_emu()
        except Exception:
            print(f"skipping SNR {s} due to exception", file=sys.stderr)
            traceback.print_exc()

    api.close()

    if len(dk) == 0:
        print(f"no nrf9160dk devices detected", file=sys.stderr)
        sys.exit(1)

    while True:
        try:
            for d in dk:
                d.handle_data()
                time.sleep(0.01)
        except KeyboardInterrupt:
            print("Got CTRL-C, quitting...")
            break
