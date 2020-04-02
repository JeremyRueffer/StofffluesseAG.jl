# nCLD.jl
#
#   Functions to parse errors, status values, and warnings from the nCLD
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Junior Research Group NITROSPHERE
# Julia 1.3.1
# 03.02.2020
# Last Edit: 11.02.2020

#include("/home/jeremy/BF-Eddy/Code/Julia/Jeremy/nCLD.jl")

mutable struct nCLD_Status
	# Byte 1
	ScrubberHeating::Bool
	ReactorChamberHeating::Bool
	AdditionalConvHeating::Bool
	HotTubingHeating::Bool
	PeltierCooling::Bool
	#not_used::Bool
	#set::Bool
	#reserved::Bool
	
	# Byte 2
	OzoneGenerator::Bool
	CalValve::Bool
	VacuumPump::Bool
	BypassPressureRegulator::Bool
	Recorder::Bool
	AUXDevice::Bool
	#set::Bool
	#reserved::Bool
	
	# Byte 3
	RemoteMode::Bool
	#reserved::Bool
	PowerUpPhase::Bool
	CalibrationActive::Bool
	StandbyOperation::Bool
	#not_used::Bool
	#set::Bool
	#reserved::Bool
	
	# Constructor for nCLD_Status type
	function nCLD_Status(status::Float64)
		nCLD_Status(Int(status))
	end # End nCLD_Status(status::Float64)
	
	# Constructor for nCLD_Status type
	function nCLD_Status(status::Int)
		# Byte 1
		ScrubberHeating = status & 2^(1-1) > 0
		ReactorChamberHeating = status & 2^(2-1) > 0
		AdditionalConvHeating = status & 2^(3-1) > 0
		HotTubingHeating = status & 2^(4-1) > 0
		PeltierCooling = status & 2^(5-1) > 0
		#not_used = status & 2^(6-1) > 0
		#set = status & 2^(7-1) > 0
		#reserved = status & 2^(8-1) > 0
		
		# Byte 1
		OzoneGenerator = status & 2^(9-1) > 0
		CalValve = status & 2^(10-1) > 0
		VacuumPump = status & 2^(11-1) > 0
		BypassPressureRegulator = status & 2^(12-1) > 0
		Recorder = status & 2^(13-1) > 0
		AUXDevice = status & 2^(14-1) > 0
		#set = status & 2^(15-1) > 0
		#reserved = status & 2^(16-1) > 0
		
		# Byte 2
		RemoteMode = status & 2^(17-1) > 0
		#reserved = status & 2^(18-1) > 0
		PowerUpPhase = status & 2^(19-1) > 0
		CalibrationActive = status & 2^(20-1) > 0
		StandbyOperation = status & 2^(21-1) > 0
		#not_used = status & 2^(22-1) > 0
		#set = status & 2^(23-1) > 0
		#reserved = status & 2^(24-1) > 0
		
		new(ScrubberHeating,ReactorChamberHeating,AdditionalConvHeating,HotTubingHeating,PeltierCooling,OzoneGenerator,CalValve,VacuumPump,BypassPressureRegulator,Recorder,AUXDevice,RemoteMode,PowerUpPhase,CalibrationActive,StandbyOperation)
	end # End of constructor
end # End of type

function Base.show(io::IO, x::nCLD_Status)
	# Byte 1
	x.ScrubberHeating ? println("\tScrubber Heating ON") : println("\tScrubber Heating OFF")
	x.ReactorChamberHeating ? println("\tReactor Chamber Heating ON") : println("\tReactor Chamber Heating OFF")
	x.AdditionalConvHeating ? println("\tAdditional Conv Heating ON") : println("\tAdditional Conv Heating OFF")
	x.HotTubingHeating ? println("\tHot Tubing Heating ON") : println("\tHot Tubing Heating OFF")
	x.PeltierCooling ? println("\tPeltier Cooling ON") : println("\tPeltier Cooling OFF")
	#not_used
	#set
	#reserved
	
	# Byte 2
	x.OzoneGenerator ? println("\tOzone Generator ON") : println("\tOzone Generator OFF")
	x.CalValve ? println("\tCal Valve ON") : println("\tCal Valve OFF")
	x.VacuumPump ? println("\tVacuum Pump ON") : println("\tVacuum Pump OFF")
	x.BypassPressureRegulator ? println("\tBypass Pressure Regulator ON") : println("\tBypass Pressure Regulator OFF")
	x.Recorder ? println("\tRecorder ON") : println("\tRecorder OFF")
	x.AUXDevice ? println("\tAUX Device ON") : println("\tAUX Device OFF")
	#set
	#reserved
	
	# Byte 3
	x.RemoteMode ? println("\tRemote Mode") : print("")
	#reserved
	x.PowerUpPhase ? println("\tPower Up Phase") : print("")
	x.CalibrationActive ? println("\tCalibration Active") : print("")
	x.StandbyOperation ? println("\tStandby Operation") : print("")
	#not_used
	#set
	#reserved
end

# --------------------------------------------------------------------------------

mutable struct nCLD_ErrorsWarnings
	# Byte 1: Errors
	SetupCalDataLost::Bool
	VacuumFailure::Bool
	SensorMalfunction::Bool
	ScrubberHeatingFailure::Bool
	OzonatorHighVoltageFailure::Bool
	BypassPressureOutOfRange::Bool
	FlowSensorNotCalibrated::Bool
	PeltierCoolerFailure::Bool
	
	# Byte 2: Errors
	ConverterHeatingFailure::Bool
	ReactorHeatingFailure::Bool
	TubingHeatingFailure::Bool
	SampleCalFlowOutOfRange::Bool
	HardwareTypeChanged::Bool
	CalibrationError::Bool
	InletPressureO3OutOfRange::Bool
	PMTError::Bool
	
	# Byte 3: Warnings
	ConverterLifetime::Bool
	PumpMaintenance::Bool
	InstrumentTemperatureTooLow::Bool
	InstrumentTemperatureTooHigh::Bool
	BypassOutOfRange::Bool
	InletPressureO3TooLow::Bool
	#Unused::Bool
	#Unused::Bool
	
	# Bytle 4: Warnings
	RangeAOverflow::Bool
	OzoneNotConstant::Bool
	#Unused::Bool
	#Unused::Bool
	RangeBOverflow::Bool
	#Unused::Bool
	#Unused::Bool
	#Unused::Bool
	
	# Constructor for nCLD_ErrorsWarnings type
	function nCLD_ErrorsWarnings(status::Float64)
		nCLD_ErrorsWarnings(Int(status))
	end # End nCLD_ErrorsWarnings(status::Float64)
	
	# Constructor for nCLD_ErrorsWarnings type
	function nCLD_ErrorsWarnings(status::Int)
		# Byte 1: Errors
		SetupCalDataLost = status & 2^(1-1) > 0
		VacuumFailure = status & 2^(2-1) > 0
		SensorMalfunction = status & 2^(3-1) > 0
		ScrubberHeatingFailure = status & 2^(4-1) > 0
		OzonatorHighVoltageFailure = status & 2^(5-1) > 0
		BypassPressureOutOfRange = status & 2^(6-1) > 0
		FlowSensorNotCalibrated = status & 2^(7-1) > 0
		PeltierCoolerFailure = status & 2^(8-1) > 0
		
		# Byte 2: Errors
		ConverterHeatingFailure = status & 2^(9-1) > 0
		ReactorHeatingFailure = status & 2^(10-1) > 0
		TubingHeatingFailure = status & 2^(11-1) > 0
		SampleCalFlowOutOfRange = status & 2^(12-1) > 0
		HardwareTypeChanged = status & 2^(13-1) > 0
		CalibrationError = status & 2^(14-1) > 0
		InletPressureO3OutOfRange = status & 2^(15-1) > 0
		PMTError = status & 2^(16-1) > 0
		
		# Byte 3: Warnings
		ConverterLifetime = status & 2^(17-1) > 0
		PumpMaintenance = status & 2^(18-1) > 0
		InstrumentTemperatureTooLow = status & 2^(19-1) > 0
		InstrumentTemperatureTooHigh = status & 2^(20-1) > 0
		BypassOutOfRange = status & 2^(21-1) > 0
		InletPressureO3TooLow = status & 2^(22-1) > 0
		#Unused = status & 2^(23-1) > 0
		#Unused = status & 2^(24-1) > 0
		
		# Byte 4: Warnings
		RangeAOverflow = status & 2^(25-1) > 0
		OzoneNotConstant = status & 2^(26-1) > 0
		#Unused = status & 2^(27-1) > 0
		#Unused = status & 2^(28-1) > 0
		RangeBOverflow = status & 2^(29-1) > 0
		#Unused = status & 2^(30-1) > 0
		#Unused = status & 2^(31-1) > 0
		#Unused = status & 2^(32-1) > 0
		
		new(SetupCalDataLost,VacuumFailure,SensorMalfunction,ScrubberHeatingFailure,OzonatorHighVoltageFailure,BypassPressureOutOfRange,FlowSensorNotCalibrated,PeltierCoolerFailure,ConverterHeatingFailure,ReactorHeatingFailure,TubingHeatingFailure,SampleCalFlowOutOfRange,HardwareTypeChanged,CalibrationError,InletPressureO3OutOfRange,PMTError,ConverterLifetime,PumpMaintenance,InstrumentTemperatureTooLow,InstrumentTemperatureTooHigh,BypassOutOfRange,InletPressureO3TooLow,RangeAOverflow,OzoneNotConstant,RangeBOverflow)
	end # End of constructor
end # End of type

function Base.show(io::IO, x::nCLD_ErrorsWarnings)
	# No Errors or Warnings at all?
	if x.SetupCalDataLost || x.VacuumFailure || x.SensorMalfunction || x.ScrubberHeatingFailure || x.OzonatorHighVoltageFailure || x.BypassPressureOutOfRange || x.FlowSensorNotCalibrated || x.PeltierCoolerFailure || x.ConverterHeatingFailure || x.ReactorHeatingFailure || x.TubingHeatingFailure || x.SampleCalFlowOutOfRange || x.HardwareTypeChanged || x.CalibrationError || x.InletPressureO3OutOfRange || x.PMTError || x.ConverterLifetime || x.PumpMaintenance || x.InstrumentTemperatureTooLow || x.InstrumentTemperatureTooHigh || x.BypassOutOfRange || x.InletPressureO3TooLow || x.RangeAOverflow || x.OzoneNotConstant || x.RangeBOverflow == false
		println("No errors or warnings.")
	else
		# Byte 1: Errors
		x.SetupCalDataLost ? println("\tSetup and Calibration Data Lost") : print("")
		x.VacuumFailure ? println("\tVacuum Failure") : print("")
		x.SensorMalfunction ? println("\tMalfunction of a sensor or regulation loop") : print("")
		x.ScrubberHeatingFailure ? println("\tScrubber heating failure") : print("")
		x.OzonatorHighVoltageFailure ? println("\tOzonator high voltage failure") : print("")
		x.BypassPressureOutOfRange ? println("\tBypass pressure out of range") : print("")
		x.FlowSensorNotCalibrated ? println("\tFlow sensor not calibrated") : print("")
		x.PeltierCoolerFailure ? println("\tPeltier cooling failure") : print("")
		
		# Byte 2: Errors
		x.ConverterHeatingFailure ? println("\tConverter heating failure") : print("")
		x.ReactorHeatingFailure ? println("\tReactor heating failure") : print("")
		x.TubingHeatingFailure ? println("\tTubing heating failure") : print("")
		x.SampleCalFlowOutOfRange ? println("\tSample / Cal flow out of range") : print("")
		x.HardwareTypeChanged ? println("\tHardware def.! I-Type changed!") : print("")
		x.CalibrationError ? println("\tCalibration Error") : print("")
		x.InletPressureO3OutOfRange ? println("\tInlet pressure O3 out of range") : print("")
		x.PMTError ? println("\tPMT Error") : print("")
		
		# Byte 3: Warnings
		x.ConverterLifetime ? println("\tConverter lifetime exceeded") : print("")
		x.PumpMaintenance ? println("\tPump maintenance requried") : print("")
		x.InstrumentTemperatureTooLow ? println("\tInstrument temperature too low") : print("")
		x.InstrumentTemperatureTooHigh ? println("\tInstrument temperature too high") : print("")
		x.BypassOutOfRange ? println("\tBypass out of allowed range") : print("")
		x.InletPressureO3TooLow ? println("\tInlet pressure O3 too low") : print("")
		#x.Unused ? println("\t") : print("")
		#x.Unused ? println("\t") : print("")
		
		# Byte 4: Warnings
		x.RangeAOverflow ? println("\tRange A overflow! Change Range") : print("")
		x.OzoneNotConstant ? println("\tO3-up. Ozone not constant!") : print("")
		#x.Unused ? println("\t") : print("")
		#x.Unused ? println("\t") : print("")
		x.RangeBOverflow ? println("\tRange B overflow! Change Range") : print("")
		#x.Unused ? println("\t") : print("")
		#x.Unused ? println("\t") : print("")
		#x.Unused ? println("\t") : print("")
	end
end
