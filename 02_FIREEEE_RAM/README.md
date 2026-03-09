# FIREEEE_RAM
Single clock simple dual-port RAM wrapper.

## File List
| No. | File name       |    Description     |
|:---:|:----------------|:-------------------|
|1    |README.md        |Module Specification|
|2    |FIREEEE_RAM.v    |Module              |
|3    |FIREEEE_RAM_tb.sv|Testbench           |
|4    |Sim              |Simulation Scripts  |

## Status
|        Item        |  Status  |
|:-------------------|:--------:|
|Version             |0.01      |
|Date                |2026/03/10|
|Verified            |Yes       |
|Real Machine Checked|No        |

## Verified Methods
- RTL simulation
- Code coverage

## Port Definition
### Input
Some inputs may not take effect depending on the RAM used in combination with this module. 
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|CLK_I      |Clock             |-                         |-           |No        |
|WEN_I      |Write Enable      |Synchronous               |CLK_I       |No        |
|WADDR_I    |Write Address     |Synchronous               |CLK_I       |No        |
|WDATA_I    |Write Data        |Synchronous               |CLK_I       |No        |
|REN_I      |Read Enable       |Synchronous               |CLK_I       |No        |
|RADDR_I    |Read Address      |Synchronous               |CLK_I       |No        |

### Output
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|RDATA_O    |Read Data         |Synchronous               |CLK_I       |No        |

## Parameters
Some parameters may not take effect depending on the RAM used in combination with this module.  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|DATA_WIDTH      |Data Bit Width                         |32             |
|ADDR_WIDTH      |Address Width                          |8              |
|OUT_REG_EN      |Output Register Enable                 |1'b0 (Disable) |
|RAM_INIT_FILE   |RAM Initialization File Name (Optional)|"" (None)      |

## Block Diagram  
![FIREEEE_RAM_Block](./Diagrams/Block/FIREEEE_RAM_Block.png)  

## Timing Chart
No timing chart in this module. Please see [FIREEEE_DATA_RAM](../04_FIREEEE_DATA_RAM) for actual operation.  

## Notes
- Some inputs and parametes may not take effect depending on the RAM used in combination with this module.  

## Version History
### 0.00
Initial Release of the Specification.
### 0.01
- Add module & related files. (2026/03/10)
- Add simulation & verification results. (2026/03/10)
