# ClimateDataIO.jl
#
#   Module for loading typical data file formats found in soil and atmospheric
#	sciences
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Julia 1.4.0
# 02.04.2020
# Last Edit: 09.04.2020

__precompile__(true)

"""# StofffluesseAG

Miscellaneous functions for the Stoffflüße AG 

For more specific information see each functions' help.

---

`dirlist`: List the files and folders in a given folder

`findnewton`: Find a value in an ordered vector

`nanmax`: Find the maximum value in an array, ignoring NaN and missing values

`nanmin`: Find the minimum value in an array, ignoring NaN and missing values

`nanmean`: Find the mean value of an array, ignoring NaN and missing values

`nCLD_ErrorsWarnings`: Parse the error and warning values from the Eco Physics nCLD

`nCLD_Status`: Parse the status values from the Eco Physics nCLD

`timestamp_aerodyne`: Parse timestamps from Aerodyne data files

`timestamp_lgr`: Parse timestamps from Los Gatos Research (LGR) data files

`timestamp_licor` : Parse timestamps from Licor data files

`work_hours` : Calculate worked hours or time remaining

### SBF Functions
`sbf_load`: Load Stoffflüße Binary Files (.sbf)

`sbf_read`: Read an individual Stoffflüße Binary File (.sbf)

---

#### Requirements
* DataFrames
* Dates
* Statistics
* Test"""
module StofffluesseAG

using Dates
using DataFrames # sbf_load
using Statistics # nanmean

export work_hours,
		dirlist,
		findnewton,
		nanmin,
		nanmax,
		nanmean,
		nanstd,
		nCLD_ErrorsWarnings,
		nCLD_Status,
		sbf_read,
		sbf_load,
		timestamp,
		timestamp_aerodyne,
		timestamp_licor,
		timestamp_lgr

dir = splitdir(@__FILE__)[1]
include(joinpath(dir,"dirlist.jl"))
include(joinpath(dir,"work_hours.jl"))
include(joinpath(dir,"nanmean.jl"))
include(joinpath(dir,"nanstd.jl"))
include(joinpath(dir,"nanmin.jl"))
include(joinpath(dir,"nanmax.jl"))
include(joinpath(dir,"timestamp.jl"))
include(joinpath(dir,"sbf_read.jl"))
include(joinpath(dir,"sbf_load.jl"))
include(joinpath(dir,"sbf_header.jl"))
include(joinpath(dir,"nCLD.jl"))
include(joinpath(dir,"findnewton.jl"))

end # module
