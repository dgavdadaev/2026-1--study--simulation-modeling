```@meta
EditURL = "../scripts/daisyworld-luminosity_literate.jl"
```

Динамика модели DaisyWorld

````@example daisyworld-luminosity
# Цель
````

Построить комплексный график изменения численности маргариток,
температуры и светимости при изменяющейся солнечной активности.
Импорт библиотек

````@example daisyworld-luminosity
using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using Plots
````

## Загрузка модели

````@example daisyworld-luminosity
include(srcdir("daisyworld.jl"))

using CairoMakie
````

##Определение функции для подсчета

````@example daisyworld-luminosity
black(a) = a.breed == :black
white(a) = a.breed == :white
````

## Настройка сбора данных

````@example daisyworld-luminosity
adata = [(black, count), (white, count)]

model = daisyworld(solar_luminosity = 1.0, scenario = :ramp)

temperature(model) = StatsBase.mean(model.temperature)
mdata = [temperature, :solar_luminosity]

agent_df, model_df = run!(model, 1000; adata = adata, mdata = mdata)
````

## Построение графика

````@example daisyworld-luminosity
figure = CairoMakie.Figure(size = (600, 600));
nothing #hide
````

Численность

````@example daisyworld-luminosity
ax1 = figure[1, 1] = Axis(figure, ylabel = "daisy count")
blackl = lines!(ax1, agent_df[!, :time], agent_df[!, :count_black], color = :red)
whitel = lines!(ax1, agent_df[!, :time], agent_df[!, :count_white], color = :blue)
figure[1, 2] = Legend(figure, [blackl, whitel], ["black", "white"])
````

Температура

````@example daisyworld-luminosity
ax2 = figure[2, 1] = Axis(figure, ylabel = "temperature")
````

Светимость

````@example daisyworld-luminosity
ax3 = figure[3, 1] = Axis(figure, xlabel = "tick", ylabel = "luminosity")
lines!(ax2, model_df[!, :time], model_df[!, :temperature], color = :red)
lines!(ax3, model_df[!, :time], model_df[!, :solar_luminosity], color = :red)
````

Оформление

````@example daisyworld-luminosity
for ax in (ax1, ax2); ax.xticklabelsvisible = false; end
figure
````

## Сохранение

````@example daisyworld-luminosity
save(plotsdir("daisy_luminosity.png"), figure)
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

