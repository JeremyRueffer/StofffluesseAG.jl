# work_hours.jl
#
#   Calculate time spent working
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.4.0
# 30.03.2020
# Last Edit: 02.04.2020

# include("D:\\Code\\Julia\\Jeremy\\work_hours.jl")

"# work_hours(times...,diffs::Bool=false)

`work_hours(\"8:21\",\"12:16\",\"13:20\",\"15:45\",\"16:30\",\"19:00\")` Calculate total work hours\n
* **time...**::String = List of times as strings in H:MM or HH:MM format

====  Summing Time Periods  ====\n
\t08:21:00 -> 12:16:00\n
\t13:20:00 -> 15:45:00\n
\t16:30:00 -> 19:00:00\n

Total: 08:50:00,  +1 hour, 2 minutes

---

#### Keywords:\n
* diffs::Bool = Show each time difference, False is default
* goal::Time = Target working ours, Time(7,48) is default\n\n"
function work_hours(times...;diffs::Bool=false,goal::Time=Time(7,48))
	#################
	##  Constants  ##
	#################
	dfmt = Dates.DateFormat("HH:MM")
	
	##############
	##  Checks  ##
	##############
	for test = 1:1:length(times)
		# Check that each input is a string
		isa(times[test],String) ? nothing : error("All input times must be strings")
		
		# Check that each input matches H:MM or HH:MM formats
		match(r"^[0-2]?[0-9]\:[0-5][0-9]",times[test]) == nothing ? error(times[test] * " is not of the form H:MM or HH:MM") : nothing
	end
	
	#################
	##  Calculate  ##
	#################
	println("====  Summing Time Periods  ====")
	isodd(length(times)) ? endTime = length(times) - 1 : endTime = length(times)
	sumTime = Time(0)
	for t=1:2:endTime
		dt = Time(times[t+1],dfmt) - Time(times[t],dfmt)
		if diffs
			dtString = ",\tdt = " * string(Time(dt))
		else
			dtString = ""
		end
		println("\t" * string(Time(times[t],dfmt)) * " -> " * string(Time(times[t+1],dfmt)) * dtString)
		sumTime += dt
	end
	
	# Odd number of times given
	if isodd(length(times))
		checkoutTime = Time(Time(times[end]).instant + goal.instant - sumTime.instant)
		println("\t" * string(Time(times[end],dfmt)) * " -> " * string(checkoutTime) * " (assuming a full work day)")
	end
	
	# Final Numbers
		if goal-sumTime > Nanosecond(0)
		println("\nTotal: " * string(sumTime) *",  " * string(Dates.canonicalize(Dates.CompoundPeriod(goal-sumTime))) * " remaining")
	else
		println("\nTotal: " * string(sumTime) * ",  +" * string(Dates.canonicalize(Dates.CompoundPeriod(sumTime-goal))))
	end
end