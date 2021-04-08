# nanmean.jl
#
#   Mean, ignoring NaNs
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.6.0
# 02.04.2020
# Last Edit: 08.04.2021

nanmean(x::Array{T}) where T <: Number = mean(filter(!isnan,x))

nanmean(x::Array{Union{T,Missing}}) where T <: Number = mean(filter(!isnan,filter(!ismissing,x)))

function nanmean(x::Matrix{T},y::Integer) where T Union{S, Union{S, Missing}} where S <: Number
	return mapslices(nanmean,x,dims=y)
end
