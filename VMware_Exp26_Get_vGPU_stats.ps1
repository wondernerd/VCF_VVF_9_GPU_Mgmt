. .\Connection.ps1 #Establish connection to virtual environment

#Get the correct object to get stats from
#$TargetEntity  = Get-Cluster -Name "Your.Cluster.Name"
$TargetEntity  = Get-VMHost -Name "Your.Host.Name"

#Display the GPU stats
get-stattype -entity $TargetEntity | where-object {$_ -match "gpu"}

#Display current values
$HostPerf = get-stattype -entity $TargetEntity | where-object {$_ -match "gpu"}
foreach ($HostHas in $HostPerf) {
    $GPUresults = Get-Stat -Entity $TargetEntity -Stat $HostHas -Realtime -MaxSamples 1 #-Start (Get-Date).AddDays(-1) -IntervalMins 5 # -Realtime -MaxSamples 2
    Write-Host $GPUresults.MetricId
    Write-Host $GPUresults.Description
    Write-Host $GPUresults.Value
}

#Do useful things with the data
#Get one day of stats from the entity
$GPUtemp = Get-Stat -Entity $TargetEntity -Stat gpu.temperature.average -Start (Get-Date).AddDays(-1) -IntervalMins 5 # -Realtime -MaxSamples 2 
#Create an array to hold just the value as integers
$CleanTempArray = @()
#Display the array
Write-Host "GPU Temp"
Write-Host $GPUtemp
#convert the array to integers
[system.Int32[]]$CleanTempArray = @($GPUtemp.Value)
#Run some basic statistics on the array of temps
($CleanTempArray | Measure-Object -StandardDeviation -Average -Sum -Maximum -Minimum)
