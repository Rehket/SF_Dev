FROM centos:centos7 AS intermediate

MAINTAINER Adam A<aalbright425@gmail.com>

RUN yum -y update
RUN yum -y clean all
RUN yum -y install dos2unix
RUN yum -y install openssh
RUN yum -y install git

# With private git repos.
# https://vsupalov.com/build-docker-image-clone-private-repo-ssh-key/

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
COPY id_rsa /root/.ssh/

RUN dos2unix /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com>> /root/.ssh/known_hosts

RUN ssh-agent bash -c 'ssh-add /root/.ssh/id_rsa;'

RUN  git clone git@github.com:rehket/SF_Dev.git --recursive

FROM centos:centos7

COPY --from=intermediate /SF_Dev /src/SF_Dev

RUN ls /src/SF_Dev

RUN ln -s /src/SF_Dev/solenopsis/ /usr/share/solenopsis/



RUN echo Good To Go!
