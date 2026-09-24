from pyVim.connect import SmartConnect
from vmware.vapi.vsphere.client import create_vsphere_client, VsphereClient


from pyVmomi import vim
import ServiceInstance #file with login info

#Create a connection to our virtual environment
si = ServiceInstance.ConnectToVC()
content = si.RetrieveContent()

#Create a performance manager object we can reference
perfManager = content.perfManager

counter_ids = [] #Base ID Values
counter_info = {} #Full ID and name pairs
counter_id_dict = {} #GPU ID name pairs

#Go through the performance objects and find anything dealing with a GPU
for counter in perfManager.perfCounter:
    full_name = f"{counter.groupInfo.key}.{counter.nameInfo.key}.{counter.rollupType}"
    counter_info[counter.key] = full_name
    if "gpu" in full_name:
        print(f"ID: {counter.key} | Metric: {full_name}")
        counter_ids.append(counter.key)
        counter_id_dict.update({counter.key : full_name})

#get the desired host object
host = content.searchIndex.FindByDnsName(dnsName="Your.Host.Name", vmSearch=False)

metrics = [vim.PerformanceManager.MetricId(counterId=cid, instance="*") for cid in counter_ids]

#Create a query spec
query = vim.PerformanceManager.QuerySpec(
        entity=host,
        metricId=metrics,
        intervalId=20, 
        maxSample=1
    )

#Get results from the query spec
perf_results = perfManager.QueryPerf(querySpec=[query])

#Loop through the query and display the results
for result in perf_results:
    for metric_value in result.value:
        counter_id = metric_value.id.counterId
        # Fetch the most recent value from the value array
        #If it has no value set the value to 0
        latest_val = metric_value.value[-1] if metric_value.value else 0
        print(f"Description: {counter_id_dict[counter_id]} | Value: {latest_val}")
