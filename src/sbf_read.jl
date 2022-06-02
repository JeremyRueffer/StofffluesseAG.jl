# sbf_read.jl
#
#	Read Stoffflüsse Binary Format data from CLD - Gill R3.vi
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.7.0
# 19.12.2017
# Last Edit: 02.06.2022

# A Labview string will have a four byte dimension array before the actual data
# s = String(read(fid,UInt8,5))
# a = Int64(read(fid,UInt16)) # Read little-endian UInt16 and convert it to Int64
# p_val = read(fid,Float64) # Read little-endian Float64

using DataFrames

"""# sbf_read

Load a single SBF (Stoffflüsse Binary Format) file

---

### Examples

`header_info, data = sbf_read(\"K:\\\\Data\\\\Site_20171222_125500.sbf\")` Load he data from the file into a dataframe, data, converting the first column to DateTime. header_info is an array of strings representing the \'description\' of the file, the \'column names\', \'units\' for each column (m/s, K, °C, etc.), \'data types\' for each column (Float64, UInt16, etc.), and each column\'s \'conversion equations\'.

---

`sbf_read(F)`\n
* **F**::String = File name, including path
"""
function sbf_read(src::String)
	#################
	##  Functions  ##
	#################
	function timestamp_aerodyne(t::Float64)::DateTime
		return DateTime(1904,1,1,1,0,0) + Dates.Second(floor(t)) + Dates.Millisecond(floor(1000(t - floor(t))))
	end
	
	#################
	##  Constants  ##
	#################
	fid = open(src,"r")
	magicbytes = read!(fid,Array{Int8}(undef,2))
	if magicbytes != Int8[63,42]
		close(fid)
		error(src * " is not a CLD/QCL/Gill binary file")
	end
	
	########################
	##  Read Header Info  ##
	########################
	fid,description,cols,units,types,conversions,lsize = sbf_header(fid)
	
	############################
	##  Calculate line count  ##
	############################
	pos_datastart = position(fid)
	fsize = filesize(src)
	lcount = Int(floor((fsize - pos_datastart)/lsize))
	
	#################
	##  Load Data  ##
	#################
	d = DataFrame(types,Symbol[Symbol(i) for i in cols],lcount,makeunique=true)
	colcount = length(cols)
	for i=1:lcount
		d[i,1] = timestamp_aerodyne(read(fid,Float64))
		for j=2:colcount
			d[i,j] = read(fid,types[j])
		end
		read(fid,Int8)
	end
	
	# Completeness Check
	if !eof(fid)
		@warn("\t" * src * " was closed early")
	end
	
	close(fid)
	
	return [description,cols,units,types,conversions], d
end
