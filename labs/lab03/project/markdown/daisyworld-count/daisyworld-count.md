```@meta
EditURL = "../scripts/daisyworld-count_literate.jl"
```

# График изменения числа маргариток

## Цель
# Построить график числа динамики популяций черных и белых маргариток

## Импорт библиотек

````@example daisyworld-count
using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using Plots
````

## Загрузка модели

````@example daisyworld-count
include(srcdir("daisyworld.jl"))

using CairoMakie
````

## Определение функций для расчета

````@example daisyworld-count
black(a) = a.breed == :black
white(a) = a.breed == :white
````

## Настройка сбора данных

````@example daisyworld-count
adata = [(black, count), (white, count)]
````

## Запуск симуляции

````@example daisyworld-count
model = daisyworld(; solar_luminosity = 1.0)
agent_df, model_df = run!(model, 1000; adata)
````

## Построение графиков

````@example daisyworld-count
figure = Figure(size = (600, 400));
ax = figure[1, 1] = Axis(figure, xlabel = "tick", ylabel = "daisy count")
blackl = lines!(ax, agent_df[!, :time], agent_df[!, :count_black], color = :black)
whitel = lines!(ax, agent_df[!, :time], agent_df[!, :count_white], color = :orange)
Legend(figure[1, 2], [blackl, whitel], ["black", "white"], labelsize = 12)
````

figure
## Сохранение

````@example daisyworld-count
save(plotsdir("daisy_count.png"), figure)
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

