# FIREEEE_RAM_CTRL
Single clock simple dual-port RAM controller.

## File List
| No. | File name |    Description     |
|:---:|:----------|:-------------------|
|1    |README.md  |Module Specification|

## Status
|  Item  |  Status  |
|:-------|:--------:|
|Version |0.00      |
|Date    |2026/03/07|
|Verified|No        |

## Port Definition
### Input
Some inputs may not take effect depending on the RAM used in combination with this module. 
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|CLK_I      |Clock             |-                         |-           |No        |
|WEN_I      |Write Enable      |Synchronous               |CLK_I       |No        |
|N_RST_I    |Synchronous Reset |Synchronous               |CLK_I       |Yes       |

### Output
| Port name |   Description    |Synchronous / Asynchronous|Clock Domain|Active low|
|:----------|:-----------------|:------------------------:|:----------:|:--------:|
|WADDR_O    |Write Address     |Synchronous               |CLK_I       |No        |
|REN_O      |Read Enable       |Synchronous               |CLK_I       |No        |
|RADDR_O    |Read Address      |Synchronous               |CLK_I       |No        |

## Parameters  
| Parameter name |             Description               | Default Value |
|:---------------|:--------------------------------------|:-------------:|
|ADDR_WIDTH      |Address Width                          |8              |

## Block Diagram  
TBD  
## Timing Chart
TBD  
## Notes
- TBD  
## Version History
### 0.00
Initial Release of the Specification.