# sbf_load.jl
#
#   Load an SBF binary file, converting as much as possible in the process
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.2.0
# 25.01.2018
# Last Edit: 02.04.2020

# A Labview string will have a four byte dimension array before the actual data
# s = String(read(fid,UInt8,5))
# a = Int64(read(fid,UInt16)) # Read little-endian UInt16 and convert it to Int64
# p_val = read(fid,Float64) # Read little-endian Float64

"""# sbf_load

Load SBF (Stoffflüsse Binary Format) files and convert the values if conversions are available and readable

---

### Examples

`header_info, data = sbf_load(\"K:\\\\Data\\\\Site_20171222_125500.sbf\")` Load the data from the file into a dataframe, data, converting the first column to DateTime. header_info is an array of strings representing the \'description\' of the file, the \'column names\', \'units\' for each column (m/s, K, °C, etc.), \'data types\' for each column (Float64, UInt16, etc.), and each column\'s \'conversion equations\'.\n\n
`header_info, data = sbf_load(\"K:\\\\Data\\\\Site_20171222_125500.sbf\")` Load the data from the file into a dataframe, data, converting the first column to DateTime. header_info is an array of strings representing the \'description\' of the file, the \'column names\', \'units\' for each column (m/s, K, °C, etc.), \'data types\' for each column (Float64, UInt16, etc.), and each column\'s \'conversion equations\'.\n\n
`header_info, data = sbf_load(\"Bavaria\",\"K:\\\\Data\",DateTime(2018,1,1),DateTime(2018,2,15,16))` Load all SBF files with the \"Bavaria\" prefix from the \"K:\\Data\" directory\n\n
`header_info, data = sbf_load(\"Bavaria\",\"K:\\\\Data\",DateTime(2018,1,1),DateTime(2018,2,15,16))` Load SBF files from the \"K:\\Data\" directory between January 1, 2018 and February 15, 2018 @ 16:00\n\n
`header_info, data = sbf_load(\"Bavaria\",\"K:\\\\Data\",DateTime(2018,1,1),DateTime(2018,2,15,16),verbose=true,veryverbose=true)` Load the time data from the previous example but show loading progress and column information

---

`sbf_load(F,verbose=false,veryverbose=false)`\n
* **F**::String = File name, including path
* **verbose**::Bool (optional) = Display information about the loading/processing, FALSE is default
* **veryverbose**::Bool (optional) = Display column names, units, and conversions for each file loaded, FALSE is default

`sbf_load(root_name,directory,mindate,maxdate;verbose=false,veryverbose=false)`\n
* **root_name**::String = Root name of the series of files to be loaded, \"Bavaria\" in the case of \"Bavaria_20180226_162200.sbf\"
* **directory**::String = Directory where the SBF files are locoated
* **mindate**::DateTime (optional) = Start of the time period to load, DateTime(0) is default
* **maxdate**::DateTime (optional) = End of the time period to load, DateTime(9999) is default
* **verbose**::Bool (optional) = Display information about the loading/processing, FALSE is default
* **veryverbose**::Bool (optional) = Display column names, units, and conversions for each file loaded, FALSE is default
"""
function sbf_load(root::String,src::String,mindate::DateTime=DateTime(0),maxdate::DateTime=DateTime(9999);verbose=false,veryverbose=false)
	##############
	##  Checks  ##
	##############
	!isdir(src) ? error(src * " is not a directory") : nothing
	
	#########################
	## List and Sort Files ##
	#########################
	verbose ? println("Listing SLT Files") : nothing
	(files,folders) = dirlist(src,regex=Regex(root * "_\\d{8}_\\d{6}\\.sbf\$"))
	
	# Parse File Dates
	verbose ? println("Sorting " * string(length(files)) * " Files") : nothing
	dfmt = Dates.DateFormat("yyyymmdd_HHMMSS")
	fdates = Array{DateTime}(undef,length(files))
	for i=1:1:length(files)
		fdates[i] = DateTime(files[i][end-18:end-4],dfmt)
	end
	
	# Remove files beyond the given time bounds
	f = findall(mindate .<= fdates .< maxdate)
	fdates = fdates[f]
	files = files[f]
	
	# Sort the Files By Date
	f = sortperm(fdates)
	fdates = fdates[f]
	files = files[f]
	
	# If no files are found return nothing
	if isempty(files)
		return Array{Any}(undef,0),DataFrame()
	end
	
	#################
	##  Load Data  ##
	#################
	verbose ? println("\t1: " * files[1]) : nothing
	prev_folder = dirname(files[1]) # Previous directory
	header_info, data = sbf_load(files[1],verbose=verbose,veryverbose=veryverbose)
	header_info = [[files[1];header_info]]
	for j=2:1:length(files)
		if verbose
			if dirname(files[j]) == prev_folder
				println("\t" * string(j) * ": " * basename(files[j]))
			else
				println("\t" * string(j) * ": " * files[j])
			end
		end
		header_temp, data_temp = sbf_load(files[j],verbose=verbose,veryverbose=veryverbose)
		header_temp = [files[j];header_temp]
		
		# Compare Headers
		if header_info[end][3] == header_temp[3] && header_info[end][4] == header_temp[4]
			data = [data;data_temp]
			
			if header_info[end][2] != header_temp[2] || header_info[end][5] == header_temp[5] || header_info[end][6] == header_temp[6]
				header_info = [header_info;[header_temp]]
			end
		else
			println("##  ERROR  ##")
			
			println(files[j])
			for k=2:1:length(header_info[end][3])
				println("\t" * header_info[end][3][k] * "(" * header_info[end][4][k] * ")")
			end
			
			println(files[j-1])
			for k=2:1:length(header_temp[3])
				println("\t" * header_temp[3][k] * "(" * header_temp[4][k] * ")")
			end
			
			error("File headers do not match. See above error information")
		end
	end
	
	return header_info, data
end # sbf_load(root::String,src::String;mindate::DateTime=DateTime(0),maxdate::DateTime=DateTime(9999),verbose::Bool=false)

function sbf_load(src::String;verbose::Bool=false,veryverbose::Bool=false)
	#################
	##  Constants  ##
	#################
	fid = open(src,"r")
	magicbytes = read!(fid,Array{Int8}(undef,2))
	if magicbytes != Int8[63,42]
		close(fid)
		error(src * " is not a Stoffflüsse binary (SBF) file")
	end
	
	########################
	##  Read Header Info  ##
	########################
	fid,description,cols,units,types,conversions,lsize = sbf_header(fid)
	types[1] = Float64 # Temporary until files are updated
	types0 = deepcopy(types) # Copy the original types for loading purposes
	
	#####################################
	##  Generate Conversion Functions  ##
	#####################################
	# Regular Expressions
	regex1 = r"^\w\/\-?\d+(\.\d+)?$" # Equations of the form x/1234 or x/123.423
	regex2 = r"^\-?\d+(\.\d+)?\w\+(\()\-?\d+(\.\d+)?(\))$" # Equations of the form 12.3456x+(-12.3456)
	regex2a = r"\-?\d+(\.\d+)?" # Find the number before the variable
	regex3 = r"^(\()\-?\d+(\.\d+)?\/\-?\d+(\.\d+)?(\))\w\+(\()\-?\d+(\.\d+)?(\))$" # Equations of the form (641.23523/-12.3456)x+(-12.3456)
	
	# Simple Functions
	dn = function doNothing(x);return x;end
	cv = function convert_to_Float64(x);return convert(Float64,x);end
	
	# Generated Functions
	F = fill!(Array{Function}(undef,length(conversions)),dn)
	for i=1:length(conversions)
		if occursin("timestamp",lowercase(cols[i])) || occursin("time",lowercase(cols[i]))
			if conversions[i] == "Seconds since January 1, 1904"
				veryverbose ? println("\t\t" * string(i) * ": Timestamp = Seconds since January 1, 1904") : nothing
				F[i] = function timestamp_aerodyne(t)
					DateTime(1904,1,1,1,0,0) + Dates.Second(floor(t)) + Dates.Millisecond(floor(1000(t - floor(t))))
				end
				types[i] = DateTime # For saving purposes
			end
		else
			if types[i] != Bool
				#println("F[" * string(i) * "] = function (y::" * string(types0[i]) * ")::Float64;x = convert(Float64,y);return " * conversions[i] * ";end")
				#F[i] = eval(parse("function (y::" * string(types0[i]) * ")::Float64;x = convert(Float64,y);return " * conversions[i] * ";end"))
				if occursin(regex1,replace(conversions[i]," " => ""))
					# Equations of the form x/1234 or x/123.423
					f1 = findall((in)("/"),conversions[i])
					y = Base.parse(Float64,conversions[i][f1[1] + 1:end])
					veryverbose ? println("\t\t" * string(i) * ": " * cols[i] * "(" * units[i] * ") = x/" * string(y)) : nothing
					if types[i] == Float64
						F[i] = function (x)
							return x/y
						end
					else
						F[i] = function (x)
							return convert(Float64,x)/y
						end
					end
				elseif occursin(regex2,replace(conversions[i]," " => ""))
					# Equations of the form 12.3456x+(-12.3456)
					f1 = findall((in)("("),conversions[i])
					f2 = findall((in)(")"),conversions[i])
					m = Meta.parse(match(regex2a,conversions[i]).match)
					b = Base.parse(Float64,conversions[i][f1[1] + 1:f2[1] - 1])
					veryverbose ? println("\t\t" * string(i) * ": " * cols[i] * "(" * units[i] * ") = " *string(m) * "x + (" * string(b) * ")") : nothing
					if types[i] == Float64
						F[i] = function (x)
							return m*x + b
						end
					else
						F[i] = function (x)
							return m*convert(Float64,x) + b
						end
					end
				elseif occursin(regex3,replace(conversions[i]," " => ""))
					# Equations of the form (641.23523/-12.3456)x+(-12.3456)
					f1 = findall((in)("("),conversions[i])
					f2 = findall((in)(")"),conversions[i])
					f3 = findall((in)("/"),conversions[i])
					m1 = Base.parse(Float64,conversions[i][f1[1] + 1:f3[1] - 1])
					m2 = Base.parse(Float64,conversions[i][f3[1] + 1:f2[1] - 1])
					b = Base.parse(Float64,conversions[i][f1[2] + 1:f2[2] - 1])
					veryverbose ? println("\t\t" * string(i) * ": " * cols[i] * "(" * units[i] * ") = (" *string(m1) * "/" * string(m2) * ")x + (" * string(b) * ")") : nothing
					if m2 != 0
						m = m1/m2
						if types[i] == Float64
							F[i] = function (x)
								return m*x + b
							end
						else
							F[i] = function (x)
								return m*convert(Float64,x) + b
							end
						end
					else
						verbose ? println("\t\t" * string(i) * ": " * cols[i] * "(" * units[i] * ") = x") : nothing
						F[i] = cv
					end
				else
					verbose ? println("\t\t" * string(i) * ": " * cols[i] * "(" * units[i] * ") = x") : nothing
					F[i] = cv
				end
				types[i] = Float64 # For saving purposes
			else
				F[i] = dn # Convert value to Float64
				#	F[i] = eval(parse("x -> " * conversions[i]))
			end
		end
	end
	
	############################
	##  Calculate line count  ##
	############################
	pos_datastart = position(fid)
	fsize = filesize(src)
	lcount = Int(floor((fsize - pos_datastart)/lsize))
	
	#################
	##  Load Data  ##
	#################
	d = DataFrame(types,Symbol[Symbol(i) for i in cols],lcount,makeunique=true) # Preallocate dataframe
	
	colcount = length(cols)
	for i=1:lcount
		for j=1:colcount
			d[i,j] = F[j](read(fid,types0[j])) # Read and convert
		end
		read!(fid,Array{Int8}(undef,1)) # Skip the end of line character
	end
	
	# Completeness Check
	if !eof(fid)
		warn("\t" * src * " was closed early")
	end
	
	close(fid)
	
	return [description,cols,units,types,conversions], d
end
