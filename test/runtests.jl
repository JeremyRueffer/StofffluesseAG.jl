# timestamp.jl
#
#   Convert difference timestamps
#
# Jeremy Rüffer
# Thünen Institut
# Institut für Agrarklimaschutz
# Julia 1.4.0
# 02.04.2020
# Last Edit: 02.04.2020

using StofffluesseAG
using Test

println("\n=======================================================")
println("============  StofffluesseAG Module Tests  ============")
println("=======================================================")

@testset "timestamp_licor Test" begin
    @test (1.481490002e9,4.9999872e7) == timestamp_licor(DateTime(2016,12,11,22,0,2,50)) || "TIMESTAMP_LICOR: timestamp_licor(DateTime(2016,12,11,22,0,2,50)) output incorrect, should be (1.481490002e9,4.9999872e7)"
    @test DateTime(2016,12,11,22,0,2,550) == timestamp_licor(1481490002,550000000) || "TIMESTAMP_LICOR: timestamp_licor(1481490002,550000000) output incorrect, should be 2016-12-11T22:00:02.55"
end
println("\n\n")

@testset "timestamp_lgr Test" begin
    @test DateTime(2017,5,15,15,13,47,994) == timestamp_lgr("15/05/2017 15:13:47.994") || "TIMESTAMP_LGR: timestamp_lgr(\"15/05/2017 15:13:47.994\") output incorrect, should be 2017-05-15T15:13:47.994"
    @test "15/05/2017 15:13:47.993" == timestamp_lgr(DateTime(2017,5,15,15,13,47,993)) || "TIMESTAMP_LGR: timestamp_lgr(DateTime(2017,5,15,15,13,47,993)) output incorrect, should be \"15/05/2017 15:13:47.993\""
end
println("\n\n")

@testset "timestamp_aerodyne Test" begin
    @test DateTime(2017,5,11,0,0,0,510) == timestamp_aerodyne(3577305600.510) || "TIMESTAMP_AERODYNE: timestamp_aerodyne(3577305600.510) output incorrect, should be 2017-05-11T00:00:00.51"
    @test 3577305600.510 == timestamp_aerodyne(DateTime(2017,5,11,0,0,0,510)) || "TIMESTAMP_AERODYNE: timestamp_aerodyne(DateTime(2017,5,11,0,0,0,510)) output incorrect, should be 3577305600.510"
end
println("\n\n")

@testset "dirlist Test" begin
    dir = joinpath(splitdir(@__FILE__)[1],"dirtest")
    targetFiles = Array{String}(undef,4)
    targetFiles[1] = joinpath(dir,"a.txt")
    targetFiles[2] = joinpath(dir,"b.txt")
    targetFiles[3] = joinpath(dir,"c.txt")
    targetFiles[4] = joinpath(dir,"subfolder","d.txt")
    targetFolders = Array{String}(undef,1)
    targetFolders[1] = joinpath(dir,"subfolder")
    @test (targetFiles[1:3], targetFolders) == dirlist(dir,recur=1) || "DIRLIST: dirlist(dir,recur=1) output incorrect"
    @test (targetFiles, targetFolders) == dirlist(dir,recur=2) || "DIRLIST: dirlist(dir,recur=2) output incorrect"
end
println("\n\n")

@testset "NaN Tests" begin
    x = [1.0,NaN,3.0,2.0]
    @test 1.0 == nanmin(x) || "NANMIN: nanmin([1.0,NaN,3.0,4.0]) output incorrect, should be 1.0"
    @test 3.0 == nanmax(x) || "NANMAX: nanmax([1.0,NaN,3.0,4.0]) output incorrect, should be 3.0"
    @test 2.0 == nanmean(x) || "NANMEAN: nanmean([1.0,NaN,3.0,4.0]) output incorrect, should be 2.0"
end
println("\n\n")

@testset "nCLD Tests" begin
    @test false == nCLD_Status(0).AUXDevice || "nCLD_Status(0).AUXDevice should be FALSE"
    @test false == nCLD_Status(0).AdditionalConvHeating || "nCLD_Status(0).AdditionalConvHeating should be FALSE"
    @test false == nCLD_Status(0).BypassPressureRegulator || "nCLD_Status(0).BypassPressureRegulator should be FALSE"
    @test false == nCLD_Status(0).CalValve || "nCLD_Status(0).CalValve should be FALSE"
    @test false == nCLD_Status(0).CalibrationActive || "nCLD_Status(0).CalibrationActive should be FALSE"
    @test false == nCLD_Status(0).HotTubingHeating || "nCLD_Status(0).HotTubingHeating should be FALSE"
    @test false == nCLD_Status(0).OzoneGenerator || "nCLD_Status(0).OzoneGenerator should be FALSE"
    @test false == nCLD_Status(0).PeltierCooling || "nCLD_Status(0).PeltierCooling should be FALSE"
    @test false == nCLD_Status(0).PowerUpPhase || "nCLD_Status(0).PowerUpPhase should be FALSE"
    @test false == nCLD_Status(0).ReactorChamberHeating || "nCLD_Status(0).ReactorChamberHeating should be FALSE"
    @test false == nCLD_Status(0).Recorder || "nCLD_Status(0).Recorder should be FALSE"
    @test false == nCLD_Status(0).RemoteMode || "nCLD_Status(0).RemoteMode should be FALSE"
    @test false == nCLD_Status(0).ScrubberHeating || "nCLD_Status(0).ScrubberHeating should be FALSE"
    @test false == nCLD_Status(0).StandbyOperation || "nCLD_Status(0).StandbyOperation should be FALSE"
    @test false == nCLD_Status(0).VacuumPump || "nCLD_Status(0).VacuumPump should be FALSE"
    
    @test false == nCLD_Status(42).AUXDevice || "nCLD_Status(0).AUXDevice should be FALSE"
    @test false == nCLD_Status(42).AdditionalConvHeating || "nCLD_Status(0).AdditionalConvHeating should be FALSE"
    @test false == nCLD_Status(42).BypassPressureRegulator || "nCLD_Status(0).BypassPressureRegulator should be FALSE"
    @test false == nCLD_Status(42).CalValve || "nCLD_Status(0).CalValve should be FALSE"
    @test false == nCLD_Status(42).CalibrationActive || "nCLD_Status(0).CalibrationActive should be FALSE"
    @test true == nCLD_Status(42).HotTubingHeating || "nCLD_Status(0).HotTubingHeating should be TRUE"
    @test false == nCLD_Status(42).OzoneGenerator || "nCLD_Status(0).OzoneGenerator should be FALSE"
    @test false == nCLD_Status(42).PeltierCooling || "nCLD_Status(0).PeltierCooling should be FALSE"
    @test false == nCLD_Status(42).PowerUpPhase || "nCLD_Status(0).PowerUpPhase should be FALSE"
    @test true == nCLD_Status(42).ReactorChamberHeating || "nCLD_Status(0).ReactorChamberHeating should be TRUE"
    @test false == nCLD_Status(42).Recorder || "nCLD_Status(0).Recorder should be FALSE"
    @test false == nCLD_Status(42).RemoteMode || "nCLD_Status(0).RemoteMode should be FALSE"
    @test false == nCLD_Status(42).ScrubberHeating || "nCLD_Status(0).ScrubberHeating should be FALSE"
    @test false == nCLD_Status(42).StandbyOperation || "nCLD_Status(0).StandbyOperation should be FALSE"
    @test false == nCLD_Status(42).VacuumPump || "nCLD_Status(0).VacuumPump should be FALSE"
end
println("\n\n")

@testset "findnewton Tests" begin
    data = collect(1:1000)
    @test 400 == findnewton(data,400) || "FINDNEWTON: findnewton(data,400) should return 400"
    @test 999 == findnewton(data,999) || "FINDNEWTON: findnewton(data,999) should return 999"
    @test 1 == findnewton(data,1) || "FINDNEWTON: findnewton(data,1) should return 1"
    @test 42 == findnewton(data,42) || "FINDNEWTON: findnewton(data,42) should return 42"
    @test 500 == findnewton(data,500) || "FINDNEWTON: findnewton(data,500) should return 500"
end
println("\n\n")

println("=====  StoffflüßeAG Tests Complete  =====")