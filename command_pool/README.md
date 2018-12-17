# Command Pool

Shellscript based solution for runnin series of commands on a fixed size threadpool.

# Usage

```Shell
TEMP=$(./command_pool.sh "NEW")              # Create tmp command list
./command_pool.sh ADD "$TEMP" grep ..| curl  # Add to tmp command list
./command_pool.sh ADD "$TEMP" ...            # Add another command and so forth
./command_pool.sh RUN "$TEMP" 5              # Run command list file in <5>
threads
```