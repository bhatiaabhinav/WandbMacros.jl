macro wandblog(exs...)
    step = nothing
    kwargs = Any[]
    for ex in exs
        if ex isa Expr && ex.head === :(=)
            k, v = ex.args
            if !(k isa Symbol)
                k = Symbol(k)
            end
            if k == :step
                step = esc(v)
                continue
            end
            push!(kwargs, Expr(:kw, k, esc(v)))
        elseif ex isa Expr && ex.head === :... # Keyword splatting
            push!(kwargs, esc(ex))
        else
            k, v = ex, ex
            if !(k isa Symbol)
                k = Symbol(k)
            end
            if k == :step
                step = esc(v)
                continue
            end
            push!(kwargs, Expr(:kw, k, esc(v)))
        end
    end
    return quote
        if !("JULIA_NO_WANDB" in keys(ENV)) || ENV["JULIA_NO_WANDB"] == "" || ENV["JULIA_NO_WANDB"] == "false" || ENV["JULIA_NO_WANDB"] == false
            kw = Dict(pairs((;$(kwargs...))))
            wandb.log(kw, step=$step)
        end
    end
end
