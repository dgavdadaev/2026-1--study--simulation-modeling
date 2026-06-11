```@meta
EditURL = "../scripts/daisyworld_literate.jl"
```

Модель DaisyWorld - базовая визуализация

````@example daisyworld
# Цель
````

Визуализация моделей на шагах 0, 5 и 40
Импорт библиотек

````@example daisyworld
using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using Plots
````

## Загрузка модели

````@example daisyworld
include(srcdir("daisyworld.jl"))

using CairoMakie
model = daisyworld()
````

## Настройка визуализации

````@example daisyworld
daisycolor(a::Daisy) = a.breed
````

## Шаг 0

````@example daisyworld
plotkwargs = (
    agent_color=daisycolor, agent_size = 20, agent_marker = '✿',
    heatarray = :temperature,
    heatkwargs = (colorrange = (-20, 60),),
)
plt1, _ = abmplot(model; plotkwargs...)
````

## Шаг 5

````@example daisyworld
step!(model, 5)
plt2, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
````

## Шаг 40

````@example daisyworld
step!(model, 40)
plt3, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
````

## Сохранение

````@example daisyworld
save(plotsdir("daisy_step001.png"), plt1)
save(plotsdir("daisy_step005.png"), plt2)
save(plotsdir("daisy_step040.png"), plt3)
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

