# 🔥FIREEEE🔥
🔥**FIREEEE** (**FIR** filter as **E**asily, **E**xpandable, **E**nhanceable and **E**mbedded) is the open-source Verilog module for implementing serial FIR filters to the FPGA.🔥  
![status](https://img.shields.io/badge/status-Spec_design-yellow)
![language](https://img.shields.io/badge/language-Verilog-blue)
![verification](https://img.shields.io/badge/hardware-not_tested-lightgrey)
![license](https://img.shields.io/badge/license-CERN--OHL--P_v2-blue)

## Overview
🔥**FIREEEE**🔥 is a configurable serial FIR filter engine for FPGA-based audio DSP applications and the successor to the [FIR_x2](https://github.com/AUDIY/FIR_x2) project.   

While [FIR_x2](https://github.com/AUDIY/FIR_x2) focused on x2 oversampling, 🔥**FIREEEE**🔥 extends this functionality with support for standard unity-rate filtering as well as power-of-two oversampling (e.g., ×2, ×4, ×8, …) without decimation.  

The core is designed for scalability and flexible integration: internal hardware resources such as RAM and ROM can be inferred from RTL or replaced with vendor-specific IP blocks, enabling optimized implementations across a wide range of FPGA platforms.

## Usage
This is under construction.

## Verified Devices
This is under construction.

## FAQ
### 1. What is a “serial” FIR filter?
A serial FIR filter (a.k.a single-MAC FIR filter) is an architecture that uses one multiplier and one adder per channel to perform sequential multiply-accumulate operations. This approach significantly reduces hardware usage and is well suited for FPGA designs with limited arithmetic resources.
### 2. What motivated this project?
Many FIR filter implementations on GitHub use fully parallel multipliers and adders. While they achieve high throughput, the tap count is often limited by hardware resources. Vendor-generated FIR IPs typically use serial architectures but lack portability. This project aims to provide a portable FIR filter capable of supporting very long tap counts.
### 3. Why was the license changed from CERN-OHL-W v2 to CERN-OHL-P v2 (on [FIR_x2](https://github.com/AUDIY/FIR_x2))?
The main reason is usability. 🔥**FIREEEE**🔥 aims to support both inferred and vendor-specific RAM/ROM implementations. Using CERN-OHL-W v2 would require distributing modified design sources under the same license when redistributed. To allow more flexible integration, this project adopts the more permissive CERN-OHL-P v2.
### 4. Can I contribute to the development?
Absolutely! If you would like to improve any part of this repository—including the specification—please fork the repository and submit a pull request. Questions and bug reports are also welcome contributions. You can start by posting in the Q&A section under Discussions.

## License under CERN-OHL-P v2
Copyright AUDIY 2026.

This source describes Open Hardware and is licensed under the [CERN-OHL-P v2](https://github.com/AUDIY/FIREEEE/blob/main/LICENSE).

You may redistribute and modify this source and make products using it under the terms of the CERN-OHL-P v2 (https:/cern.ch/cern-ohl).

This source is distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE.
Please see the CERN-OHL-P v2 for applicable conditions.
