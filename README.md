# 🔥FIREEEE🔥
![Version](https://img.shields.io/badge/Version-v0.01-green)
![status](https://img.shields.io/badge/status-Spec_under_revision-yellow)
![license](https://img.shields.io/badge/license-CERN--OHL--P_v2-blue)
![language](https://img.shields.io/badge/language-Verilog-blue)
![verification](https://img.shields.io/badge/hardware-not_tested-lightgrey)  
🔥**FIREEEE** (<ins>**FIR**</ins> filter as <ins>**E**</ins>asily, <ins>**E**</ins>xpandable, <ins>**E**</ins>nhanceable and <ins>**E**</ins>mbedded) is the open-source Verilog module for implementing serial FIR filters to the FPGA.🔥  

## Overview
🔥**FIREEEE**🔥 is a configurable serial FIR filter implementation written in Verilog and a successor to the [FIR_x2](https://github.com/AUDIY/FIR_x2) project.

The goal of this project is to provide a portable FIR filter architecture capable of supporting very long tap counts while remaining compatible with a wide range of FPGA toolchains.  

<ins>**Note: The project is currently under active development. The specification and the Verilog modules are being developed in parallel.**</ins>

## Features

- Configurable serial FIR filter architecture
- Designed for FPGA implementations
- Supports very long tap counts
- Vendor-independent design where possible

## Usage
This is under construction.

## Verified Devices
This is under construction.

## FAQ
### 1. What is a “serial” FIR filter?
A serial FIR filter (also known as a single-MAC FIR filter) is an architecture
that performs multiply-accumulate operations sequentially using a single
multiplier and adder per channel.

This approach reduces hardware resource usage and is suitable for FPGA designs
where arithmetic resources are limited.
### 2. What motivated this project?
Many FIR filter implementations on GitHub use fully parallel multipliers and
adders. While this allows high throughput, the number of taps is limited
by hardware resources.

Vendor-generated FIR IP cores often use serial architectures, but they are
typically vendor-specific and lack portability.

This project aims to provide a portable FIR filter architecture capable of
supporting very long tap counts.
### 3. Why was the license changed from CERN-OHL-W v2 to CERN-OHL-P v2 (on [FIR_x2](https://github.com/AUDIY/FIR_x2))?
The main reason is usability.

🔥**FIREEEE**🔥 aims to support both inferred and vendor-specific RAM/ROM
implementations. Using CERN-OHL-W v2 would require modified design sources
to be released under the same license when the design is redistributed.

To allow more flexible integration with different FPGA toolchains, this
project adopts the more permissive CERN-OHL-P v2.
### 4. Can I contribute to the development?
Yes, contributions are welcome!

If you would like to improve any part of this repository, including the
specification, please fork the repository and submit a pull request.

Questions and bug reports are also welcome. You can start by
posting in the Q&A section under Discussions.
## License under CERN-OHL-P v2
Copyright AUDIY 2026.

This source describes Open Hardware and is licensed under the [CERN-OHL-P v2](https://github.com/AUDIY/FIREEEE/blob/main/LICENSE).

You may redistribute and modify this source and make products using it under the terms of the CERN-OHL-P v2 (https:/cern.ch/cern-ohl).

This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE.
Please see the CERN-OHL-P v2 for applicable conditions.
