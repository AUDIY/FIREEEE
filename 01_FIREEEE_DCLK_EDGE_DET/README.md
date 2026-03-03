# FIREEEE_DCLK_EDGE_DET
Data clock edge detector.

## File List
| No. | File name |    Description     |
|:---:|:----------|:-------------------|
|1    |README.md  |Module Specification|

## Status
|  Item  |  Status  |
|:-------|:--------:|
|Version |0.00      |
|Date    |2026/03/04|
|Verified|No        |

## Port Definition
### Input
| Port name |         Description          |
|:----------|:-----------------------------|
|CLK_I      |Clock                         |
|DCLK_I     |Data Clock                    |
|DATA_I     |Data                          |
|N_RST_I    |Synchronous Reset (Active LOW)|

### Output
| Port name |   Description    |
|:----------|:-----------------|
|DCLK_O     |Data Clock        |
|DATA_O     |Data              |
|POS_DET_O  |Positive Edge Flag|
|NEG_DET_O  |Negative Edge Flag|

## Parameters
| Parameter name |     Description      | Default Value |
|:---------------|:---------------------|:-------------:|
|DATA_WIDTH      |Data Bit Width        |8              |
|IN_REG_EN       |Input Register Enable |1'b1           |
|OUT_REG_EN      |Output Register Enable|1'b1           |

## Block Diagram
Note: This diagram shows the schematic when IN_REG_EN == 1'b1 and OUT_REG_EN == 1'b1.
![FIREEEE_DCLK_EDGE_DET_Block](./Diagrams/Block/FIREEEE_DCLK_EDGE_DET_Block.png)
## Timing Chart
Note: This diagram shows the timing when IN_REG_EN == 1'b1 and OUT_REG_EN == 1'b1.
![FIREEEE_DCLK_EDGE_DET_Waveform](./Diagrams/Waveform/FIREEEE_DCLK_EDGE_DET_waveform.png)
## Notes
- This module asserts a flag for exactly one CLK_I cycle immediately after the rising edge and immediately after the falling edge of DCLK_O, respectively.
- For the generation of POS_DET_O and NEG_DET_O, a minimum latency of one CLK_I cycle is introduced to both Data clock (DCLK_I & DCLK_O) and Data (DATA_I & DATA_O).
- One additional register stage can optionally be inserted at both the input side and the output side for skew adjustment. When both stages are enabled, the maximum input-to-output latency becomes three CLK_I cycles.
- N_RST_I is an active-low asynchronous reset. The deassertion of the reset must be synchronized to CLK_I outside this module before being applied (e.g. [ARESETN_SYNC](https://github.com/AUDIY/AUDIY_Verilog_IP/tree/main/ARESETN_SYNC)).
- The frequency of CLK_I must be at least twice the frequency of DCLK_I.
- POS_DET_O and NEG_DET_O are mutually exclusive and will never be asserted simultaneously.
## Version History
### 0.00
Initial Release of the Specification.
