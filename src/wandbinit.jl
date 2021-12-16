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
            if Sys.iswindows()
                if :settings in keys(kw) && !isnothing(kw[:settings].start_method) && kw[:settings].start_method != "thread"
                    @warn "wandb initialization is known to crash on Windows OS if the setting `start_method` is not \"thread\". You have specified start_method=\"$(kw[:settings].start_method)\". But don't worry! This @wandbinit macro is going to override that setting and set it to \"thread\" for you. But next time, either specify settings=wandb.Settings(start_method=\"thread\") or don't set the start_method. In the latter case, this macro will set it to \"thread\" automatically for you and inform you gently."
                    kw[:settings].start_method = "thread"
                elseif :settings in keys(kw) && isnothing(kw[:settings].start_method)
                    @info "Adding kwarg start_method=\"thread\" to wandb.Settings to avoid a crash on Windows OS (a known issue)."
                    kw[:settings].start_method = "thread"
                elseif !(:settings in keys(kw))
                    @info "Adding kwarg settings=wandb.Settings(start_method=\"thread\") to avoid a crash on Windows OS (a known issue)."
                    kw = (kw..., settings=wandb.Settings(; start_method="thread"))
                end
            end
            wandb.init(; kw...)
        end
    end
end