ARG DEP_IMAGE_TAG=<default-application-image-tag>
ARG DEP_IMAGE_REG=<default-application-image-registry>
FROM ${DEP_IMAGE_REG}streams-application-el7:$DEP_IMAGE_TAG

ENV MY_USER_NAME=myuser
ENV MY_USER=1000360000
ENV MY_GROUP=1000360000

USER root

# Add new user; if you want the application pod to run as this user you need to also add a SecurityContext to your custom application resource template.
RUN groupadd ${MY_USER_NAME} --gid ${MY_GROUP}  &&           \
    useradd  ${MY_USER_NAME} --uid ${MY_USER} --no-log-init \
             --gid  ${MY_GROUP} --create-home --shell /bin/bash && \
			 echo '[[ -e ${STREAMS_PROFILE} ]] && source ${STREAMS_PROFILE}'     \
             >> /home/${MY_USER_NAME}/.bashrc

# IMPORTANT: Switch back to a user. The USER cannot be root. The ${STREAMS_USER_NAME} environment variable can be used to switch to the default application user: streamsapp.
USER "${MY_USER}"
WORKDIR "/home/${USER}"
