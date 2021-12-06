macro wandbconfig(exs...)
    kwargs = Any[]
    for ex in exs
        if ex isa Expr && ex.head === :(=)
            k, v = ex.args
            if !(k isa Symbol)
                k = Symbol(k)
            end
            push!(kwargs, Expr(:kw, k, esc(v)))
        elseif ex isa Expr && ex.head === :... # Keyword splatting
            push!(kwargs, esc(ex))
        else
            k, v = ex, ex
            if !(k isa Symbol)
                k = Symbol(k)
            end
            push!(kwargs, Expr(:kw, k, esc(v)))
        end
    end
    return quote
        if !("JULIA_NO_WANDB" in keys(ENV)) || ENV["JULIA_NO_WANDB"] == "" || ENV["JULIA_NO_WANDB"] == "false" || ENV["JULIA_NO_WANDB"] == false
            kw = Dict(pairs((;$(kwargs...))))
            wandb.config.update(kw, allow_val_change=true)
        end
    end
end
