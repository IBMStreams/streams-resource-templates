Your application might require additional dependencies that are not provided by the Streams default application image.  To include additional dependencies, you must build a custom Docker image and create a custom resource template. 

The following files are included in this example: 
- Dockerfile - The file contains the instructions for how to assemble the image.
  - In this example, we are installing the R rpm. The R package allows applications to create scoring R models with Streams. 
  - To include the R rpm, manually download it from the Fedora website, see [EPEL-RPM](https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm). The RPM file must be included in the same directory as the Dockerfile when you build the Docker image. Use Docker commands to build, tag, and publish the Docker image to a registry. 

- example-resource-template-new-dep.yaml - This file shows how to specify the custom image in a custom resource template.  The registry-name, registry-prefix, image-name and image-tag that are specified in the template must be the same as specified on Docker build commands. 

**NOTES** 
1. The custom application image must be built from the Streams default application image (streams-application-el7).  You must have a Docker environment to build the image and the URL to a Docker registry to publish the image.  You need to know the Docker registry URL and Docker tag for the default application image for your environment. This will be specified in the Dockerfile. Ask your administrator for this information.
2. For details on the docker registry when using the Red Hat OpenShift® registry see this step, [Collecting information about your cluster from your administrator](https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/cpd/install/svc-install-prep.html?view=kc$svc-install-prep__collect-info). Locate the _Registry_location_ and _Registry_from_cluster_ table entries.
3. The configuration map must include the label streams-custom-resource-template: "true". This label ensures that when a Streams instance is provisioned or an existing Streams instance is edited, the configuration map name can be selected from the list of available configuration maps.
4. The container name in the pod specification template must be controller.

**Hint**: If the Docker registry you use requires authorization to pull images, you might need to generate a Docker pull secret and specify it in the template. For example, replace <secret-name> with the secret name for your Docker image.  If you don't require a secret, remove these lines from the template.
  ```
     imagePullSecrets:
       - name: <secret-name>     
  ``` 

For details about how to build a Docker image and specify the custom resource templates, see [**_Customizing your application resource_**]https://www.ibm.com/support/knowledgecenter/SSQNUZ_latest/svc-streams/admin-app.html).

A sample script, build.sh, can be used to build a custom application image. For details, download the script and run ./build.sh --help. The script is in the base directory for this repository.
