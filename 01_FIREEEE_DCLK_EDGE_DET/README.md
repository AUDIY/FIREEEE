# FIREEEE_DCLK_EDGE_DET
Data clock edge detector.

## File List
| No. | File name |    Description     |
|:---:|:----------|:-------------------|
|1    |README.md  |Module Specification|

## Status
| Item  | Status |
|:------|:-------|
|Version||
|Date   ||

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
|ADDR_WIDTH      |Address Bit Width     |8              |
|IN_REG_EN       |Input Register Enable |1'b1           |
|OUT_REG_EN      |Output Register Enable|1'b1           |

## Block Diagram
## Timing Chart
### Input
### Output
## Notes
## Version History
