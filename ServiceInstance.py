from pyVim.connect import SmartConnect
from vmware.vapi.vsphere.client import create_vsphere_client, VsphereClient
import requests
import urllib3
from pyVmomi import vim

#import vmware.vapi
#from vmware.vapi.sddc_manager.client import create_sddc_manager_client

def ConnectToVC ():
    session = requests.session()
    # Disable cert verification for demo purpose.
    # This is not recommended in a production environment.
    session.verify = False
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    # Connect to a SDDC Manager Server using username and password
    si = SmartConnect(host='###.###.###.###', 
                        user='YourUserHere@yourDomain.EXT', 
                        pwd='YourPasswordHere',
                        disableSslCertValidation=session)
    #print("All done connecting")
    return si
