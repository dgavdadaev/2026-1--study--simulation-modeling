# scripts/sir_parametric_scan.jl
using DrWatson
@quickactivate "project"
using Agents, DataFrames, Plots, CSV, Statistics
include(srcdir("sir_model.jl"))

# Полное параметрическое сканирование модели SIR.
#
# В отличие от scan_beta.jl (где варьировался только β), здесь
# перебирается небольшой грид по нескольким ключевым параметрам:
# β_und, detection_time, death_rate, infection_period,
# reinfection_probability. Грид сокращён (2-3 значения на параметр),
# чтобы расчёт укладывался в разумное время на слабой машине.

function run_one(p)
    β = p[:β_und]
    model = initialize_sir(;
        Ns = [1000, 1000, 1000],
        β_und = fill(β, 3),
        β_det = fill(β / 10, 3),
        infection_period = p[:infection_period],
        detection_time = p[:detection_time],
        death_rate = p[:death_rate],
        reinfection_probability = p[:reinfection_probability],
        Is = [0, 0, 1],
        seed = p[:seed],
        n_steps = p[:n_steps],
    )

    infected_fraction(model) =
        count(a.status == :I for a in allagents(model)) / nagents(model)

    peak = 0.0
    for step in 1:p[:n_steps]
        Agents.step!(model, 1)
        frac = infected_fraction(model)
        peak = max(peak, frac)
    end

    final_inf = infected_fraction(model)
    final_rec = count(a.status == :R for a in allagents(model)) / nagents(model)
    deaths = 3000 - nagents(model)

    return (peak = peak, final_inf = final_inf, final_rec = final_rec, deaths = deaths)
end

## Сокращённый грид параметров (подобран для быстрого выполнения)
param_dict = Dict(
    :β_und => [0.2, 0.5],
    :detection_time => [3, 7, 14],
    :death_rate => [0.02, 0.08],
    :infection_period => [14],
    :reinfection_probability => [0.1],
    :seed => [42],
    :n_steps => [100],
)

params_list = dict_list(param_dict)
println("Запланировано экспериментов: $(length(params_list))")

results = []
for (i, params) in enumerate(params_list)
    data = run_one(params)
    push!(results, merge(params, Dict(pairs(data))))
    println("[$i/$(length(params_list))] β=$(params[:β_und]) " *
            "detection_time=$(params[:detection_time]) " *
            "death_rate=$(params[:death_rate]) -> peak=$(round(data.peak, digits=3))")
end

df = DataFrame(results)
CSV.write(datadir("sir_parametric_scan_all.csv"), df)

## Теоретический порог R0 = beta / gamma, gamma = 1 / infection_period
df.gamma = 1.0 ./ df.infection_period
df.R0 = df.β_und ./ df.gamma

## Сводный график: пик заболеваемости vs R0, разбито по detection_time
plt = plot(xlabel = "R0 = β / γ", ylabel = "Пик доли инфицированных",
           legend = :topleft, title = "Зависимость пика эпидемии от R0")

for dt in sort(unique(df.detection_time))
    sub = sort(df[df.detection_time .== dt, :], :R0)
    plot!(plt, sub.R0, sub.peak, marker = :circle, label = "detection_time=$dt")
end

vline!(plt, [1.0], linestyle = :dash, color = :red, label = "R0 = 1 (теор. порог)")

savefig(plotsdir("sir_parametric_scan.png"))

println("Готово. Результаты: data/sir_parametric_scan_all.csv, plots/sir_parametric_scan.png")
println(df)
