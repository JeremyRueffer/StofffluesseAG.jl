# nanmean.jl
#
#   Mean, ignoring NaNs
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.4.0
# 02.04.2020
# Last Edit: 02.04.2020

nanmean(x::Array{T}) where T <: Number = mean(filter(!isnan,x))

nanmean(x::Array{Union{T,Missing}}) where T <: Number = mean(filter(!isnan,filter(!ismissing,x)))

nanmean(x::Array{T},y::Integer) where T <: Number = mean(filter(!isnan,x,y))

nanmean(x::Array{Union{T,Missing}},y::Integer) where T <: Number = mapslices(nanmean,x,y)