#!/bin/bash

# This script can be used to build a custom application image. It will login to the registry, build, tag and 
# push the image. 

########################################
# Usage
script="$(basename "$0")"
usage="usage: $script <options>  
	--namespace <openshift-namespace>
        [--registry-url <url>]
        [--registry-user <admin-user>]
        [--new-image-name <name-for-new-image>]
	[--new-image-tag <tag-for-new-image>] 
	[--default-image-tag <tag-for-based-on-image>] 
        "

########################################
# Utilities
INFO(){
    echo "`date` [$script]:" "$@"
}
DIE(){
    echo "`date` [$script]:[FATAL]:" "$@" 1>&2
    exit 1
}

########################################
# Argument parsing

# Change these values to the name and tag for your custom image.
REGISTRY_URL=`oc get route/default-route -n openshift-image-registry --template='{{ .spec.host }}'`

REGISTRY_PREFIX=
DEFAULT_APP_IMAGE_TAG=5.5.0.0-27

NEW_REGISTRY_URL=$REGISTRY_URL
NEW_REGISTRY_PREFIX=

REGISTRY_USER="kubeadmin"

# Change these values to the name and tag for your custom image.
NEW_APP_IMAGE_TAG=custom-app_${DEFAULT_APP_IMAGE_TAG}
NEW_APP_IMAGE_NAME=streams-custom-app

while (( $# > 0 )); do
    case "$1" in
        --registry-url|-r)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            REGISTRY_URL="$2"
            shift 2
            ;;
            
        --registry-user|-u)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            REGISTRY_USER="$2"
            shift 2
            ;;

        --namespace|-n)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            REGISTRY_PREFIX="$2"
            NEW_REGISTRY_PREFIX=${REGISTRY_PREFIX}
            shift 2
            ;;

        --new-image-name|-i)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            NEW_APP_IMAGE_NAME="$2"
            shift 2
            ;;

        --new-image-tag|-t)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            NEW_APP_IMAGE_TAG="$2"
            shift 2
            ;;

        --default-image-tag|-d)
            (( $# > 1)) || DIE "Missing parameter for \"$1\"."
            DEFAULT_APP_IMAGE_TAG="$2"
            shift 2
            ;;

        --help|-h)
            echo "$usage
  This script can be used to build a custom application image. It will login to the registry, build, tag and 
  push the image. The new image is based on, streams-application-el7, the IBM Streams default application
  image. The same registry is assumed for pulling the default application image and pushing the new image.
 
  To use this script:
  1. You must be logged into an OpenShift cluster.
  2. You must have docker setup on your environment and be authorized to pull and push images. The user
     to access the registry is kubeadmin. You can override the registry and user using the parameters. 
     The password is assumed to be the oc token.
  3. You must have authority to use the oc command to get the route for the Redhat Openshift cluster. 
 
    --registry-url
    -r		
        The docker registry url for the default image and new custom image. The default is 
        the Redhat Openshift external registry.
   
   --registry-user
    -u		
        The user for logging into the docker registry. The default is kubeadmin.

    --namespace
    -n
        Openshift namespace, this will be the prefix for the image. This parameter is required.

    --new-image-name
    -i
        Name for the new image. The default is $NEW_APP_IMAGE_NAME.

    --new-image-tag
    -t
        Tag to use for the custom image. The deefault is:$NEW_APP_IMAGE_TAG.

    --default-image-tag
    -d
        The Streams default application image, streams-application-el7, tag. The default is $DEFAULT_APP_IMAGE_TAG.
"
            exit 0
            ;;
    esac
done

if [[ ! $REGISTRY_URL ]]; then
   DIE "The following parameter is missing: --registry-url."
fi

if [[ ! $REGISTRY_PREFIX ]]; then
   DIE "The following parameter is missing: --namespace."
fi


INFO "***********************************"
INFO "Values:"
INFO "REGISTRY: ${REGISTRY_URL}"
INFO "REGISTRY_PREFIX: ${REGISTRY_PREFIX}"
INFO "REGISTRY_USER: ${REGISTRY_USER}"
INFO "DEFAULT_APP_IMAGE_TAG: ${DEFAULT_APP_IMAGE_TAG}"
INFO "NEW_REGISTRY_URL: ${NEW_REGISTRY_URL}"
INFO "NEW_REGISTRY_PREFIX: ${NEW_REGISTRY_PREFIX}"
INFO "NEW_APP_IMAGE_NAME: ${NEW_APP_IMAGE_NAME}"
INFO "NEW_APP_IMAGE_TAG: ${NEW_APP_IMAGE_TAG}"
INFO "***********************************"

INFO "Log in to the ${REGISTRY_URL} registry as the following user: ${REGISTRY_USER}."
docker login ${REGISTRY_URL} -u ${REGISTRY_USER} -p $(oc whoami -t)

INFO "### Building new docker image: ${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG}"
docker build --build-arg DEP_IMAGE_TAG="${DEFAULT_APP_IMAGE_TAG}" --build-arg DEP_IMAGE_REG="${REGISTRY_URL}/${REGISTRY_PREFIX}/" -t ${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG} .

INFO "### Tagging new docker image: ${NEW_REGISTRY_URL}/${NEW_REGISTRY_PREFIX}/${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG}"
docker tag ${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG} ${NEW_REGISTRY_URL}/${NEW_REGISTRY_PREFIX}/${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG}

INFO "### Pushing new docker image: ${NEW_REGISTRY_URL}/${NEW_REGISTRY_PREFIX}/${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG}"
docker push ${NEW_REGISTRY_URL}/${NEW_REGISTRY_PREFIX}/${NEW_APP_IMAGE_NAME}:${NEW_APP_IMAGE_TAG}

