# FIREEEE_ACCUM
Multiplied Data Accumulator

## File List
| No. |           File name          |        Description          |
|:---:|:-----------------------------|:----------------------------|
|1    |README.md                     |Module Specification         |
|2    |FIREEEE_ACCUM.v               |Module                       |
|3    |FIREEEE_ACCUM_tb.sv           |Testbench                    |
|4    |fireeee_accum_no_reset.v      |Instance (No Reset)          |
|5    |fireeee_accum_sync_reset.v    |Instance (Synchronous Reset) |
|6    |fireeee_accum_async_reset.v   |Instance (Asynchronous Reset)|
|7    |Sim                           |Simulation Scripts           |


## Status
|        Item        |  Status  |
|:-------------------|:--------:|
|Version             |0.01      |
|Date                |2026/04/05|
|Verified            |Yes       |
|Real Machine Checked|No        |

## Verified Methods
- RTL simulation
- Code coverage

## Port Definition
### Input
|   Port name   |       Description         |Synchronous / Asynchronous|Clock Domain|Active low|
|:--------------|:--------------------------|:------------------------:|:----------:|:--------:|
|CLK_I          |Clock                      |-                         |-           |No        |
|CLKS_I         |Data & Other Clocks        |Synchronous               |CLK_I       |No        |
|MULT_I         |Data from RAM              |Synchronous               |CLK_I       |No        |
|N_RST_I        |Synchronous Reset          |Synchronous / Asynchronous|CLK_I       |Yes       |

### Output
| Port name |    Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:------------------|:------------------------:|:----------:|:--------:|
|CLKS_O     |Data & Other Clocks|Synchronous               |CLK_I       |No        |
|ACCUM_O    |Accumulated Data   |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               |   Default Value   |
|:---------------|:--------------------------------------|:-----------------:|
|RESET_EN        |Reset Enable                           |1'b1 (Enable)      |
|ASYNC_RESET_EN  |Reset Type                             |1'b1 (Asynchronous)|
|CLKS_WIDTH      |Clocks Bit Width                       |2                  |
|MULT_WIDTH      |Multiplied Data Bit Width              |32                 |
|MARGIN_WIDTH    |Margin bit width for accumulation      |8                  |
|IN_REG_EN       |Input Register Enable                  |1'b1 (Enable)      |
|OUT_REG_EN      |Output Register Enable                 |1'b1 (Enable)      |

## Block Diagram
TBD  
## Timing Chart
TBD  
## Notes
- TBD  
## Version History
### 0.00
- Initial Release of the Specification. 
### 0.01
- Add module & related files. (2026/04/05)
- Add simulation & verification results. (2026/04/05)
