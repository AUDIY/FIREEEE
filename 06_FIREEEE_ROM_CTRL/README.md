# FIREEEE_ROM_CTRL
Single-port ROM controller.

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
|   Port name   |       Description        |Synchronous / Asynchronous|Clock Domain|Active low|
|:--------------|:-------------------------|:------------------------:|:----------:|:--------:|
|CLK_I          |Clock                     |-                         |-           |No        |
|DCLK_EDGE_DET_I|Data Clock Edge Detection |Synchronous               |CLK_I       |No        |
|N_RST_I        |Synchronous Reset         |Synchronous               |CLK_I       |Yes       |

### Output
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|REN_O      |Read Enable       |Synchronous               |CLK_I       |No        |
|RADDR_O    |Read Address      |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|ADDR_WIDTH      |Address Width                          |8 (0 - 255)    |

## Block Diagram  
TBD  
## Timing Chart
TBD    
## Version History
### 0.00
Initial Release of the Specification.  
