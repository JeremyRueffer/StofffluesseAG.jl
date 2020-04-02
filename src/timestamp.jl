# timestamp.jl
#
#   Convert difference timestamps
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 0.6
# 12.05.2017
# Last Edit: 18.06.2018

# include("/home/jeremy/BF-Eddy/Code/Julia/Jeremy/timestamp.jl")

VERSION >= v"0.7-alpha.0" ? using Dates : nothing

"""# timestamp

Parse to and from various timestamp formats: Aerodyne, Licor, and LGR (Los Gatos Research)

See the following functions for more information:
* **timestamp_aerodyne**
* **timestamp_licor**
* **timestamp_lgr**
"""
function timestamp()
	
end

"""# timestamp_aerodyne

Parse an Aerodyne timestamp to DateTime and vise versa

---

### Examples

`time = timestamp_aerodyne(3577305600.510)`\n
`05/11/2017 00:00:00.51`\n

---

`time = timestamp_aerodyne(DateTime(2017,5,11,0,0,0,510))`\n
`3577305600.510`\n

---

### Function Definitions

`time = timestamp_aerodyne(t::Number)`\n
* **t**::Number = Aerodyne timestamp
* **time**::DateTime = Converted timestamp

`time = timestamp_aerodyne(t::DateTime)`\n
* **t**::DateTime = Aerodyne timestamp
* **time**::Float64 = Converted timestamp
"""
function timestamp_aerodyne(t::Number)
	# t = 3577305600.510040 # 05/11/2017 00:00:01
	epoch_aerodyne = DateTime(1904,1,1,0,0,0)
	
	#secs = Dates.Second(floor(t))
	#millisecs = Dates.Millisecond(floor(1000(t - floor(t))))
	#time = epoch_aerodyne + secs + millisecs
	return epoch_aerodyne + Dates.Second(floor(t)) + Dates.Millisecond(floor(1000(t - floor(t))))
end

# t = DateTime(2017,4,26,9)
function timestamp_aerodyne(t::DateTime)
	epoch_aerodyne = DateTime(1904,1,1,0,0,0)
	return convert(Float64,Dates.value(t - epoch_aerodyne))/1000
end

"""# timestamp_licor

Parse an Licor timestamp to DateTime and vise versa

---

### Examples

`time = timestamp_licor(1481490002,550000000)`\n
`2016-12-11T22:00:02.05`\n

---

`seconds, nanoseconds = timestamp_licor(DateTime(2016,12,11,22,0,2,50))`\n
`1481490002,550000000`\n

---

### Function Definitions

`time = timestamp_licor(s::Number,ns::Number)`\n
* **s**::Number = Seconds
* **ns**::Number = Nanoseconds
* **time**::DateTime = Converted timestamp

`s, ns = timestamp_licor(t::DateTime)`\n
* **s**::Number = Seconds
* **ns**::Number = Nanoseconds
* **time**::DateTime = Converted timestamp
"""
function timestamp_licor(s::Number,ns::Number)
	# s = 1481490002.0 # Seconds
	# ns = 550000000.0 # Nanoseconds
	# 	=> 2016-12-11T22:00:02.55
	epoch_licor = DateTime(1970,1,1,1)
	return epoch_licor + Dates.Second(s) + Dates.Millisecond(floor(ns/1e6))
end

function timestamp_licor(t::DateTime)
	epoch_licor = DateTime(1970,1,1,1)
	s = convert(Float64,Dates.value(t - epoch_licor))/1000
	ns = 1e9s - 1e9floor(s)
	s = floor(s)
	return s, ns
end

"""# timestamp_lgr

Parse an LGR (Los Gatos Research) timestamp to DateTime and vise versa

---

### Examples

`time = timestamp_lgr("15/05/2017 15:13:47.994")`\n
`2017-15-05T15:13:47.994`\n

---

`time = timestamp_lgr(DateTime(2017,5,15,15,13,47,993))`\n
`"15/05/2017 15:13:47.994"`\n

---

### Function Definitions

`time = timestamp_lgr(t::String)`\n
* **t**::String = LGR Timestamp
* **time**::DateTime = Converted timestamp

`time = timestamp_lgr(t::DateTime)`\n
* **t**::DateTime = DateTime timestamp
* **time**::String = Converted timestamp
"""
function timestamp_lgr(t::String)
	# x = "30/01/2015 15:13:47.994"
	dfmt = Dates.DateFormat("dd/mm/yyyy HH:MM:SS.sss")
	return DateTime(t,dfmt)
end

function timestamp_lgr(t::DateTime)
	dfmt = Dates.DateFormat("dd/mm/yyyy HH:MM:SS.sss")
	return Dates.format(t,dfmt)
end
