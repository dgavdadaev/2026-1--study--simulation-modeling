# # График изменения числа маргариток
#
# ## Цель
# # Построить график числа динамики популяций черных и белых маргариток
#
# ## Импорт библиотек
using DrWatson
@quickactivate "project"
using Agents
using DataFrames
using Plots

# ## Загрузка модели
include(srcdir("daisyworld.jl"))

using CairoMakie

# ## Определение функций для расчета

black(a) = a.breed == :black
white(a) = a.breed == :white

# ## Настройка сбора данных
adata = [(black, count), (white, count)]

# ## Запуск симуляции
model = daisyworld(; solar_luminosity = 1.0)
agent_df, model_df = run!(model, 1000; adata)

# ## Построение графиков
figure = Figure(size = (600, 400));
ax = figure[1, 1] = Axis(figure, xlabel = "tick", ylabel = "daisy count")
blackl = lines!(ax, agent_df[!, :time], agent_df[!, :count_black], color = :black)
whitel = lines!(ax, agent_df[!, :time], agent_df[!, :count_white], color = :orange)
Legend(figure[1, 2], [blackl, whitel], ["black", "white"], labelsize = 12)
# figure
# ## Сохранение
save(plotsdir("daisy_count.png"), figure)