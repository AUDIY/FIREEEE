# FIREEEE_MULT
Data & Coefficient Multiplier

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
|DATA_I         |Data from RAM              |Synchronous               |CLK_I       |No        |
|COEF_I         |Filter Coefficient from ROM|Synchronous               |CLK_I       |No        |
|N_RST_I        |Synchronous Reset          |Synchronous               |CLK_I       |Yes       |

### Output
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|DCLKS_O    |Read Address      |Synchronous               |CLK_I       |No        |
|MULT_O     |Multiplied Data   |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|DATA_BIT_WIDTH  |Data Bit Width                         |32             |
|COEF_BIT_WIDTH  |Coefficient Bit Width                  |32             |
|OUT_BIT_WIDTH   |Output Data Bit Width                  |32             |
|IN_REG_EN       |Input Register Enable                  |1'b1 (Enable)  |
|OUT_REG_EN      |Output Register Enable                 |1'b1 (Enable)  |

## Block Diagram  
![FIREEEE_MULT_Block](./Diagrams/Block/FIREEEE_MULT_Block.png)
## Timing Chart
![FIREEEE_MULT_waveform_normal](./Diagrams/Waveform/FIREEEE_MULT_waveform_normal.png)
## Notes
- TBD  
## Version History
### 0.00
Initial Release of the Specification.  