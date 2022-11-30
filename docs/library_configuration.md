# IO-TEMPLATE - Library - Configuration

## 1. **`logging_cfg.yaml`**

This file controls the logging behaviour of the application. 

**Default content**:

    version: 1
    
    formatters:
      simple:
        format: "%(asctime)s [%(module)s.py  ] %(levelname)-5s %(funcName)s:%(lineno)d %(message)s"
      extended:
        format: "%(asctime)s [%(module)s.py  ] %(levelname)-5s %(funcName)s:%(lineno)d \n%(message)s"
    
    handlers:
      console:
        class: logging.StreamHandler
        level: INFO
        formatter: simple
    
      file_handler:
        class: logging.FileHandler
        level: INFO
        filename: logging_io-template.log
        formatter: extended
    
    loggers:
      io-template:
        handlers: [ console ]
    root:
      handlers: [ file_handler ]

## 2. **`settings.io_template.toml`**

This file controls the behaviour of the **IO-TEMPLATE** library. 

The customisable entries are:

| Parameter  | Default | Description                                |
|------------|---------|--------------------------------------------|
| is_verbose | true    | Display progress messages for processing.  |

The configuration parameters can be set differently for the individual environments (`dev`, `prod` and `test`).

**Examples**:
      
    [default]
    is_verbose = true
    [dev]
    [prod]
    [test]
    is_verbose = true
    ...
   
