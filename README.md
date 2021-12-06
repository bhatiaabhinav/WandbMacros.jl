# WandbMacros.jl

Convenient Julia macros for logging to [weights and biases (Wandb)](wandb.ai) dashboard.

The macros provide a Julian way of interfacing with Wandb's Python API via [PyCall](https://github.com/JuliaPy/PyCall.jl). The functionality of each macro is transparent and obvious.


## Installation instructions

```julia
using Pkg
Pkg.add("WandbMacros")
```

## Quick Start

```julia
using WandbMacros  # Automatically installs wandb (if not already installed) if PyCall.conda is true, else raises a prompt to install it.

@wandbinit project="Project1" name="Run1"  # Specify any keyword arguments that you would pass to wandb.init() in Python.

@wandbconfig seed=42 learning_rate=0.001 network_size=[64,32]  # Specify the config dictionary. Equivalent to wandb.config.update({"seed": 42, "learning_rate": 0.001, "network_size": [64,32]}, allow_val_change=True) in Python.

@wandbsave "file1.txt"  # Equivalent to wandb.save("file1.txt") in Python

@wandblog loss=0.1 accuracy=0.91 Validation/accuracy=0.75 step=100  # Equivalent to wandb.log({"loss":1, "accuracy":0.91, "Validation/accuracy":0.75}, step=100) in Python. `step` is an optional and a reserved keyword.

@wandbfinish  # equivalent to wandb.finish() in Python

```


## Pro tips

1. `using WandbMacros` also exports the PyCall object `wandb=pyimport("wandb")`, which can be used to call Wandb functions that are not covered by the macros provided in this package.

2. `@wandbinit`, `@wandbconfig` and `@wanbdlog` work like Julia's [`@info` macro](https://docs.julialang.org/en/v1/stdlib/Logging/). This allows for some powerful functionality:

    - Suppose you have the config parameters stored in a Julia dictionary named `config_dict` and it has keys of type `Symbol`, then you can splat the values by doing `@wandbconfig config_dict...`. You can also specify additional key-value pairs while splatting e.g., `@wandbconfig param1=100 config_dict...`. Similar functionality is available for `@wandblog` and `@wandbinit`. 
    - If you have a julia variable named `loss`, then instead of logging it using `@wandblog loss=loss`, you can simply do `@wandblog loss`. This can be combined with other ways of specifying the arguments e.g., `@wandblog accuracy=0.1 loss foo=x some_dict...`.


3. To run [multiple instances of wandb](https://docs.wandb.ai/guides/track/launch) in a process, do `run1 = @wandbinit project="project1" name="run1" reinit=true` and close the instance by calling `@wandfinish run1`.

4. Wandb logging can be disabled entirely (without commenting out the code) by setting environment variable `JULIA_NO_WANDB=true`, and enabled again by either unsetting the environment variable or setting it to `JULIA_NO_WANDB=false`. The environment variable can be set within the code using `ENV["JULIA_NO_WANDB"]=true`.
