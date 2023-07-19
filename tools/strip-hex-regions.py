#!/usr/bin/env python3

import sys
from intelhex import IntelHex


def main(argv):
    if len(argv) < 2:
        print("Usage: strip-hex-regions.py /path/to/in.hex /path/to/out.hex")
        sys.exit(1)

    infile = argv[0]
    outfile = argv[1]

    ih = IntelHex(infile)
    out_segments = []

    iseg = ih.segments()
    for i, (start, end) in enumerate(iseg, 1):
        print(f"Segment {i}/{len(iseg)} : {{ 0x{start:08X}, 0x{end:08X} }}")

        rsp = ""
        while rsp not in ["y", "Y", "n", "N"]:
            rsp = input("keep segment? (y/n)")

        if rsp in ["y", "Y"]:
            out_segments.append((start, end))

    if len(out_segments) > 0:
        oh = IntelHex()
        for start, end in out_segments:
            oh.merge(ih[start:end])
        oh.write_hex_file(outfile)
    else:
        print("abort: no segments copied")


if __name__ == "__main__":
    main(sys.argv[1:])
