. .\Connection.ps1
#------------- List all DPP specs -------------
$DPP_MGR = Get-View -Id 'DirectPathProfileManager-DirectPathProfileMgr'
$Spec = New-Object VMware.Vim.DirectPathProfileManagerFilterSpec
$DPP_MGR.DirectPathProfileManagerList($spec)
