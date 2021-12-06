macro wandbsave(logdir)
    quote
        if !("JULIA_NO_WANDB" in keys(ENV)) || ENV["JULIA_NO_WANDB"] == "" || ENV["JULIA_NO_WANDB"] == "false" || ENV["JULIA_NO_WANDB"] == false
            wandb.save($(esc(logdir)))
        end
    end
end
