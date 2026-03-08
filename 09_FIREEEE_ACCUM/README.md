# FIREEEE_ACCUM
Multiplied Data Accumulator

## File List
| No. | File name |    Description     |
|:---:|:----------|:-------------------|
|1    |README.md  |Module Specification|

## Status
|  Item  |  Status  |
|:-------|:--------:|
|Version |0.00      |
|Date    |2026/03/08|
|Verified|No        |

## Port Definition
### Input
|   Port name   |       Description         |Synchronous / Asynchronous|Clock Domain|Active low|
|:--------------|:--------------------------|:------------------------:|:----------:|:--------:|
|CLK_I          |Clock                      |-                         |-           |No        |
|DCLKS_I        |Data & Other Clocks        |Synchronous               |CLK_I       |No        |
|MULT_I         |Data from RAM              |Synchronous               |CLK_I       |No        |
|N_RST_I        |Synchronous Reset          |Synchronous               |CLK_I       |Yes       |

### Output
| Port name |    Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:------------------|:------------------------:|:----------:|:--------:|
|DCLKS_O    |Data & Other Clocks|Synchronous               |CLK_I       |No        |
|ACCUM_O    |Accumulated Data   |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|MULT_BIT_WIDTH  |Multiplied Data Bit Width              |32             |
|ACCUM_BIT_WIDTH |Output Data Bit Width                  |32             |
|IN_REG_EN       |Input Register Enable                  |1'b1 (Enable)  |
|OUT_REG_EN      |Output Register Enable                 |1'b1 (Enable)  |

## Block Diagram
TBD  
## Timing Chart
TBD  
## Notes
- TBD  
## Version History
### 0.00
Initial Release of the Specification.  