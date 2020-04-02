# sbf_header.jl
#
#   Read the header from an SBF binary file and return the header info and an
#		open file reference.
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.4.0
# 25.01.2018
# Last Edit: 02.04.2020

"""# sbf_header

Load SBF (Stoffflüsse Binary Format) file header information

---

### Examples

`description,cols,units,types,conversions,lsize = sbf_header(\"K:\\\\Data\\\\Site_20171222_125500.sbf\")` Load the SBF file header information.\n\n
`fid, description,cols,units,types,conversions,lsize = sbf_header(fid)` Load the SBF file header information.\n\n

---

`sbf_load(F,verbose=false,veryverbose=false)`\n
* **F**::String = File name, including path
* **verbose**::Bool (optional) = Display information about the loading/processing, FALSE is default
* **veryverbose**::Bool (optional) = Display column names, units, and conversions for each file loaded, FALSE is default

`sbf_header(source::String)`\n
* **source**::String = Source SBF file, including path

`sbf_header(fid::IOStream)`\n
* **fid**::IOStream = File ID, already opened SBF file ID
* **description**::String = File description
* **cols**::Array{String} = Column names
* **units**::Array{String} = Units of each column
* **types**::Array{DataType} = Types of each column
* **conversions**::Array{String} = Conversions for each column
* **lsize**::Int64 = Line size
"""
function sbf_header(src::String)
	if !isfile(src)
		error(src * " doesn''t exist")
	end
	
	fid = open(src,"r")
	magicbytes = read!(fid,Array{Int8}(undef,2))
	if magicbytes != Int8[63,42]
		close(fid)
		error(src * " is not a CLD/QCL/Gill binary file")
	end
	
	fid,description,cols,units,types,conversions,lsize = sbf_header(fid) # Read the header info
	close(fid)
	
	return description,cols,units,types,conversions,lsize
end

function sbf_header(fid::IOStream)
	function parse_header(h::String)
		f = findall((in)('\x1e'),h)
		parsed_header = Array{String}(undef,length(f) + 1)
		string_pos = 1
		for i=1:length(f)
			parsed_header[i] = h[string_pos:f[i]-1]
			string_pos = f[i] + 1
		end
		parsed_header[end] = h[string_pos:end]
		
		return parsed_header
	end
	
	#################################
	## Load and Parse Header Info  ##
	#################################
	read!(fid,Array{Int8}(undef,2)) # \x01, start of the header
	description = String(readuntil(fid,UInt8(03))[1:end]) # Starts with \x02, ends with \x03, \x1e delimited
	column_names_str = String(readuntil(fid,UInt8(03))[2:end]) # Starts with \x02, ends with \x03, \x1e delimited
	units_str = String(readuntil(fid,UInt8(03))[2:end]) # Starts with \x02, ends with \x03, \x1e delimited
	types_str = String(readuntil(fid,UInt8(03))[2:end]) # Starts with \x02, ends with \x03, \x1e delimited
	conversions_str = String(readuntil(fid,UInt8(03))[2:end]) # Starts with \x02, ends with \x03, \x1e delimited
	read!(fid,Array{Int8}(undef,1)) # \x04, end of the header
	
	cols = parse_header(column_names_str)
	units = parse_header(units_str)
	types_str_list = parse_header(types_str)
	conversions = parse_header(conversions_str)
	types = Array{DataType}(undef,length(cols))
	lsize = 9 # Bytes per line, start with 9 to account for the LF character at the end and the Float64 for the timestamp at the beginning
	types[1] = DateTime
	for i=2:length(types)
		types[i] = eval(Meta.parse(types_str_list[i]))
		if occursin("64",types_str_list[i])
			lsize += 8
		elseif occursin("32",types_str_list[i])
			lsize += 4
		elseif occursin("16",types_str_list[i])
			lsize += 2
		elseif occursin("8",types_str_list[i])
			lsize += 1
		end
	end
	
	# Clean up column names
	for i=1:length(cols)
		cols[i] = replace(cols[i],' ' => '_')
	end
	
	return fid, description,cols,units,types,conversions,lsize
end
