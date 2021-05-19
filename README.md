# streams-resource-templates
This repository contains examples for customizing your IBM Streams application resources. 

_An application image and application resource template are used in your application resource. A default image and resource template are included with Streams. An application resource template is a pod specification. You can use the provided image and template or create your own. A custom application resource template is defined in a configmap. The configmap is specified when provisioning or editing a service instance. There can be multiple resource templates in a configmap. You might need to create a custom image and a resource template or only create a resource template._

 
### Adding additional dependencies:
If you require additional dependencies that are not provided in the default application image, you must create a custom application image and a custom resource template. For an example, see the following directory: **CustomImageAdditionalDependencies**.

### Customizing the user:
NOTE: Running an application with a specified user UID is only supported on Streams 5.5.x.x code base.

All application pods by default are run with the streamsapp user.  If you need to run your application with a different user, you must create a custom application image and a custom resource template. For an example, see the following directory: **CustomImageNewUser**.

### Using persistent storage:
If your application requires a persistent volume claim to be mounted on your application pod, you must create a custom resource template. For an example, see the following directory: **CustomDefaultTagAndPVC**.

### Custom attributes:
If your application requires different Kubernetes characteristics than what is provided by the default application resource template (for example, your application requires specific labels and additional CPU), you must create a custom resource template.  For an example, see the following directory: **CustomDefaultTagAndPVC**.

### Use Geospatial toolkit and creating custom resource template
If you use a custom resource template and you have an application that requires the geospatial toolkit, the shared volume must be defined as an emptyDir volume. The geospatial toolkit requires more shared memory than the Docker default. For an example, see the following directory: **CustomDefaultTagAndPVC**.

### Tooling
A sample script, build.sh, can be used to build a custom application image. For details, download the script and run ./build.sh --help. The script is in the base directory for this repository.

### Reference
For details about customizing your application resoures, see [**_Customizing your application resource_**](https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/svc-streams/admin-app.html).
