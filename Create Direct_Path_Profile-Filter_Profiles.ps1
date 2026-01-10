. .\Connection.ps1
#------------- List specific DPP specs -------------
$DPP_MGR = Get-View -Id 'DirectPathProfileManager-DirectPathProfileMgr'
$Spec = New-Object VMware.Vim.DirectPathProfileManagerFilterSpec
$Spec.Names = 'NEW --> NVIDIA L4-3B profile'  #Accepts blank, single, or arrays
$DPP_MGR.DirectPathProfileManagerList($Spec)
