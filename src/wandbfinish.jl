macro wandbfinish(run)
    quote
        if !("JULIA_NO_WANDB" in keys(ENV)) || ENV["JULIA_NO_WANDB"] == "0" || ENV["JULIA_NO_WANDB"] == "false" || ENV["JULIA_NO_WANDB"] == false
            $(esc(run)).finish()
        end
    end
end

macro wandbfinish()
    quote
        if !("JULIA_NO_WANDB" in keys(ENV)) || ENV["JULIA_NO_WANDB"] == "" || ENV["JULIA_NO_WANDB"] == "false" || ENV["JULIA_NO_WANDB"] == false
            wandb.finish()
        end
    end
end
