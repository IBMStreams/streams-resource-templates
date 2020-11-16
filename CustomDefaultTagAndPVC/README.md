This directory contains an example of a custom application resource template. The example-resource-template-multi-configmap.yaml file defines a configmap containing multiple custom templates demonstrating various scenarios. The following templates are defined:
- application 
  - All jobs submitted without a specific resource tag use the default resource template called _application_, which is provided by the Streams product. You can override this template if you have additional requirements. For example, let's say you have a requirement that all resources have a special label so you can query for resources associated with your jobs. In addition, all jobs require different CPU and memory then the default values. This templates demonstrates adding a label and specifying CPU and memory.

- examplepvc 
  - You have an application that requires a persistent volume to be mounted. You must create the persistent volume claim (PVC) and define a custom resource template to mount it. For more details see [Mounting a persistent volume claim](#mounting-a-persistent-volume-claim).

**NOTES:**
1. These templates use the default application image, streams-application-el7, that is shipped with the Streams product. You need to know the Docker registry URL and Docker tag for this image and update that information in the custom templates.  Ask your administrator for this information.
2. If you use a custom resource template and you have an application that requires the geospatial toolkit, the shared volume must be defined as an emptyDir volume. The geospatial toolkit requires more shared memory than the Docker default. The _application_ template in the example yaml file shows an example of how to do this.
3. The configuration map must include the label streams-custom-resource-template: "true". This label ensures that when a Streams instance is provisioned or an existing Streams instance is edited, the configuration map name can be selected from the list of available configuration maps.
4. The container name in the pod specification template must be controller.


#### Mounting a persistent volume claim
If your application requires persistent storage, you must create the persistent volume claim (PVC) and define a custom resource template to mount it.  

To create the persistent storage, do the following tasks:
* Create a YAML file with the storage specifications for your environment.  You can use this file for an example: example-resource-template-pvc.yaml.
* Create the PVC before you submit a job that uses the examplepvc tag. Run the following command to create the PVC by using the updated YAML file:
```
 oc create -f example-resource-template-pvc.yaml.
```

Your application might require your PVC to be primed with files before you run the application. If so, you can follow the instructions in this RedHat blog:  https://www.openshift.com/blog/transferring-files-in-and-out-of-containers-in-openshift-part-3.  Another option is to use a Kubernetes job to prime the PVC. 

The persistent volume and persistent volume claim must meet the following requirements:
* The persistent volume must allow for ReadWriteMany access and the persistent volume claim must be set up with RWX access mode.
* The persistent volume claim must be scoped to the same namespace or OpenShift® project as the Streams instance.
* If your application writes to the persistent volume, the persistent volume must be writable by the following runAsUser and runAsGroup: 1000320901. If you override the user in a customized application image, the persistent volume must be writable by that user. 


## References:
For more details about how to create and specify the custom resource templates, see [Creating a Streams application resource template](https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/svc-streams/admin-app-appresource-template.html).


