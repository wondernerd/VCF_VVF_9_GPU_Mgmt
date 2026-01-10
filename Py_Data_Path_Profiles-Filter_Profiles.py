from pyVim.connect import SmartConnect
from vmware.vapi.vsphere.client import create_vsphere_client, VsphereClient
import requests
import urllib3
from pyVmomi import vim
import ServiceInstance #file with login info

si = ServiceInstance.ConnectToVC()
Content = si.RetrieveContent()

#------------- List all DPP specs -------------
DPP_Mgr = Content.directPathProfileManager
#DPP_Mgr = si.content.directPathProfileManager

#Create Filter Specification
Filter_Spec = vim.DirectPathProfileManager.FilterSpec()
Filter_Spec.names = "NEW --> NVIDIA L4-3B profile"

print(DPP_Mgr.ListDirectPathProfiles(Filter_Spec))
