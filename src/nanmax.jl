# nanmax.jl
#
#   Maximum, ignoring NaNs
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.6.0
# 02.04.2020
# Last Edit: 08.04.2021

nanmax(x::Array{T}) where T <: Number = maximum(filter(!isnan,x))

nanmax(x::Array{Union{T,Missing}}) where T <: Number = maximum(filter(!isnan,filter(!ismissing,x)))

nanmax(x::Array{T},y::Integer) where T <: Number = mapslices(nanmax,x,dims=y)
