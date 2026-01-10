. .\Connection.ps1
#------------- List DPP Stats on a cluster for a given spec -------------
$DPP_MGR = Get-View -Id 'DirectPathProfileManager-DirectPathProfileMgr'
$Spec = New-Object VMware.Vim.DirectPathProfileManagerFilterSpec
$Spec.Names = 'NEW --> NVIDIA L4-3B profile' 
#vSphere Cluster
$Cluster_View = Get-View -ViewType ClusterComputeResource -Filter @{"Name" = "GPU Cluster"}
#DPP Cluster
$DPP_Target_Entity = new-object VMware.Vim.DirectPathProfileManagerTargetCluster
$DPP_Target_Entity.Cluster = $Cluster_View.MoRef
#Target
$DPP_QC = New-Object VMware.Vim.DirectPathProfileManagerCapacityQueryByName
$DPP_QC.Name = $spec.Names
$DPP_MGR.DirectPathProfileManagerQueryCapacity($DPP_Target_Entity, $DPP_QC)
