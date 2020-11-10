By default, application resources run as the streamsapp user.  To run an application resource with a different user, you must create a custom application image and create a custom resource template. This example will demonstrate how to create and run the resource with a different user.

Included in this example are the following files:
* Dockerfile - This file contains the instructions to create an image. This image creates a new user and group with a UID in the following range:  1000360000 - 1000361000, and creates the user's home directory.
* example-resource-template-new-dep.yaml - This file shows an example of specifying the custom image in a custom resource template.  The registry-name, registry-prefix, image-name and image-tag that are specified in the template must be the same as specified on Docker build commands. To run the resource as the new user, you must define a securityContext in the template and specify the new UID as the runAsUser and runAsGroup.  

**NOTES:** 
1. The custom application image must be built from the Streams default application image (streams-application-el7).  You must have a Docker environment to build the image and the URL to a Docker registry to publish the image.  You need to know the Docker registry URL and Docker tag for the default application image for your environment. This will be specified in the Dockerfile. Ask your administrator for this information.
2. For details on the docker registry when using the Red Hat OpenShift® registry see this step, [Collecting information about your cluster from your administrator](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/install/svc-install-prep.html?view=kc$svc-install-prep__collect-info). Locate the _Registry_location_ and _Registry_from_cluster_ table entries.
3. The configuration map must include the label streams-custom-resource-template: "true". This label ensures that when a Streams instance is provisioned or an existing Streams instance is edited, the configuration map name can be selected from the list of available configuration maps.
4. The container name in the pod specification template must be controller.

**Hint**: If the Docker registry you use requires authorization to pull images, you might need to generate a Docker pull secret and specify it in the template. For example, replace <secret-name> with the secret name for your Docker image.  If you don't require a secret, remove these lines from the template.
  ```
     imagePullSecrets:
       - name: <secret-name>     
  ``` 

For details about how to build a Docker image and specify the custom resource templates, see [**_Customizing your application resource_**](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/svc-streams/admin-app.html).
