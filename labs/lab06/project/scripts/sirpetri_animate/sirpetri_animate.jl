# # Анимация SIR модели
#
# Создание GIF-анимации динамики эпидемии

using DrWatson
@quickactivate "project"

include(srcdir("SIRPetri.jl"))
using DataFrames
using Plots

function main()
    # ## Параметры
    beta = 0.3
    gamma = 0.1
    tmax = 100.0

    # ## Симуляция
    net, u0, _ = SIRPetri.build_sir_network(beta, gamma)
    df = SIRPetri.simulate_deterministic(net, u0, (0.0, tmax); saveat = 0.2, rates = [beta, gamma])

    # ## Создание анимации
    anim = @animate for i in 1:nrow(df)
        bar(
            ["S", "I", "R"],
            [df.S[i], df.I[i], df.R[i]];
            ylim = (0, 1000),
            legend = false,
            xlabel = "State",
            ylabel = "Population",
            title = "t = $(round(df.time[i], digits = 1))",
        )
    end

    # ## Сохранение
    gif(anim, plotsdir("sir_animation.gif"), fps = 10)
    println("Animation saved.")
end

main()