# Static Solidity Source Code Optimizer
This project is created to optimize inefficient gas patterns in Solidity source code. The main source code of this project is written in Python on Python Notebook.

## Usage
The optimizer works in four steps:
1. Configuring options: user set optimization options and miscellaneous options.
2. Load smart contracts: user import their smart contracts in files directory or through manual input.
3. Initialize optimizer: libraries and utility functions are defined for optimization.
4. Optimization process: optimizer optimize smart contracts, which then the result is outputted at the end.

## Options
### Optimization Options (Default: True)
`VARIABLE_PACKING`: enable variable packing optimization with best fit algorithm.

`DEFAULT_VALUE`: enable removing inefficient default value from any variable definition.

`INCREMENT_OPERATOR`: enable converting post-fix increment into pre-fix increment where applicable.

`DECREMENT_OPERATOR`: enable converting post-fix decrement into pre-fix increment where applicable.

`BOOLEAN_IF_CHECK`: enable deleting explicit boolean checks.

`INDEX_EVENT_VARIABLE`: enable indexing event variables except `bytes` or `string` data types.


### Risky Optimization Options (Default: False)
`PRECOMPUTE_VARIABLE_VALUE`: enable precomputing variable value that references other variable in a group/island.

`PRECOMPUTE_VALUE`: enable precomputing any arithmatic operations where applicable.

`INDEX_EVENT_STRING_BYTES`: enable indexing `bytes` and `string` data types.


### Miscellaneous Options
`FILES_DIR`: directory consisting user's Solidity source code(s). Default is set to `sol`.

`OUTPUT_DIR`: directory where the optimized source code will be outputted. Default is set to `optimized`.
