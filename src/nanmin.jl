# nanmin.jl
#
#   Minimum, ignoring NaNs
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.6.0
# 02.04.2020
# Last Edit: 08.04.2021

nanmin(x::Array{T}) where T <: Number = minimum(filter(!isnan,x))

nanmin(x::Array{Union{T,Missing}}) where T <: Number = minimum(filter(!isnan,filter(!ismissing,x)))

nanmin(x::Array{T},y::Integer) where T <: Number = mapslices(nanmin,x,dims=y)
