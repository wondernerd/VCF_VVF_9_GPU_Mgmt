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
$DPP_MGR.DirectPathProfileManagerQueryCapacity($DPP_Target_Entity, $DPP_QC)
