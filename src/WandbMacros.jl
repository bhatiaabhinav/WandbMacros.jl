module WandbMacros

using PyCall

export wandb, @wandbinit, @wandbconfig, @wandbsave, @wandblog, @wandbfinish

const wandb = PyNULL()

function __init__()
    copy!(wandb, pyimport_conda("wandb", "wandb", "conda-forge"))
end

include("wandbinit.jl")
include("wandbconfig.jl")
include("wandbsave.jl")
include("wandblog.jl")
include("wandbfinish.jl")

end
