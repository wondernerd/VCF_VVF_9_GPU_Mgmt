. .\Connection.ps1
#------------- List DPP Stats on a host for a given spec -------------
$DPP_MGR = Get-View -Id 'DirectPathProfileManager-DirectPathProfileMgr'
$Spec = New-Object VMware.Vim.DirectPathProfileManagerFilterSpec
$Spec.Names = 'NEW --> NVIDIA L4-3B profile'  #Accepts blank, single, or arrays
#vSphere Host
$Host_View = Get-View -ViewType HostSystem -Filter @{"Name" = "ESX04"}
#DPP Host
$DPP_Target_Entity = new-object VMware.Vim.DirectPathProfileManagerTargetHost
$DPP_Target_Entity.Host = $Host_View.MoRef
#Target
$DPP_QC = New-Object VMware.Vim.DirectPathProfileManagerCapacityQueryByName
$DPP_QC.Name = $spec.Names

#Priming Read
$DPP_Usage = $DPP_MGR.DirectPathProfileManagerQueryCapacity($DPP_Target_Entity, $DPP_QC)

Write-Output("Setting Vars:")
$Reserve_VM_Space = 2
$VM_Floor = 0
$Starting_VM = $DPP_Usage.Consumed + 1

Write-Output("Starting Loop")
Write-Output("DPP Remaining: " + $DPP_Usage.remaining)
Write-Output("Reserved Space: " + $Reserve_VM_Space)
while ($DPP_Usage.remaining -gt $Reserve_VM_Space) {
    #Create VM Name
    $VM_Name = "VM_GPU_0" + $Starting_VM
    Write-Output("Starting VM: " + $VM_Name)
    $Next_VM = Get-VM -Name $VM_Name
    Start-VM -VM $Next_VM
    $DPP_Usage = $DPP_MGR.DirectPathProfileManagerQueryCapacity($DPP_Target_Entity, $DPP_QC)
    $Starting_VM = $Starting_VM + 1
}
Write-Output("No more VMs to start. Cleaning up") 
Start-Sleep -Seconds 20
Write-Output("Starting Value is: $Starting_VM")
while ($DPP_Usage.remaining -gt 1 -and $Starting_VM -gt 1){
    $Starting_VM = $Starting_VM - 1
    #Create VM Name
    $VM_Name = "VM_GPU_0" + $Starting_VM
    Write-Output("Stoppinng VM: " + $VM_Name)
    $Next_VM = Get-VM -Name $VM_Name
    Stop-VMGuest -VM $Next_VM -Confirm:$false
    if ($Starting_VM -gt $VM_Floor){
        do {
            Start-Sleep -Seconds 5
            $Next_VM = Get-VM -Name $VM_Name
            $VM_Power = $Next_VM.PowerState
            Write-Output("The power state is: " + $VM_Power)
        } until ($VM_Power -eq "PoweredOff")
    }
    else {
        Write-Output("Reached the floor. Bye!")
        break
    }
    $DPP_Usage = $DPP_MGR.DirectPathProfileManagerQueryCapacity($DPP_Target_Entity, $DPP_QC)
}
