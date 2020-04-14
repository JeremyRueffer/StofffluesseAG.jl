# nanstd.jl
#
#   Standard deviation, ignoring NaNs
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.4.0
# 09.04.2020
# Last Edit: 09.04.2020

nanstd(x::Array{T}) where T <: Number = std(filter(!isnan,x))

nanstd(x::Array{Union{T,Missing}}) where T <: Number = std(filter(!isnan,filter(!ismissing,x)))
