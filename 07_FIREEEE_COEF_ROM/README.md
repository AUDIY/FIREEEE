# FIREEEE_COEF_ROM
Filter Coefficient ROM

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
|   Port name   |      Description        |Synchronous / Asynchronous|Clock Domain|Active low|
|:--------------|:------------------------|:------------------------:|:----------:|:--------:|
|CLK_I          |Clock                    |-                         |-           |No        |
|DCLK_EDGE_DET_I|Data Clock Edge Detection|Synchronous               |CLK_I       |No        |
|N_RST_I        |Synchronous Reset        |Synchronous               |CLK_I       |Yes       |

### Output
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|RADDR_O    |Read Address      |Synchronous               |CLK_I       |No        |
|RDATA_O    |Read Data         |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|ROM_DATA_WIDTH  |Data Width                             |32             |
|ROM_ADDR_WIDTH  |Address Width                          |8 (0 - 255)    |
|OUT_REG_EN      |Output Register Enable                 |1'b0 (Disable) |
|ROM_INIT_FILE   |ROM Initialization Data File Name      |"init.hex"     |

## Block Diagram  
![FIREEEE_COEF_ROM_Block](./Diagram/Block/FIREEEE_COEF_ROM_Block.png)
## Timing Chart
TBD  
## Notes
- TBD  
## Version History
### 0.00
Initial Release of the Specification.  
