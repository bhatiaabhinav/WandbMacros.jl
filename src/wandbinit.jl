macro wandbinit(exs...)
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
            kw = pairs((;$(kwargs...)))
            if "settings" in keys(kw)
                run = wandb.init(; kw...)
            else
                run = wandb.init(; settings=wandb.Settings(start_method="thread"), kw...)
            end
            run
        end
    end
end