ARG DEP_IMAGE_TAG=<default-application-image-tag>
ARG DEP_IMAGE_REG=<default-application-image-registry>

FROM ${DEP_IMAGE_REG}streams-application-el7:$DEP_IMAGE_TAG

ADD epel-release-latest-7.noarch.rpm /tmp

# Example of how to add additional resources
# Add epel repo.  Images are based on UBI: https://developers.redhat.com/articles/ubi-faq/
USER root

# Install prereqs for R
RUN yum -y clean all && rm -rf /var/cache/yum/* &&\
    yum install -y /tmp/epel-release-latest-7.noarch.rpm &&\
    yum install -y R R-core R-core-devel  &&\
    yum clean all

# IMPORTANT: Switch back to a user. The USER cannot be root. The ${STREAMS_USER_NAME} environment variable can be used to switch to the default application user: streamsapp.
USER "${STREAMS_USER_NAME}"
WORKDIR "/home/${USER}"
