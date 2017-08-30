FROM ubuntu 
MAINTAINER Jeganathan Swaminathan <jegan@tektutor.org> <http://www.tektutor.org>

ENV http_proxy 'http://10.19.16.165:8080'
ENV https_proxy 'https://10.19.16.165:8080'

# Let's ensure that all package repositories are up to date 
RUN apt-get update

# We need ssh server so that Jenkins Master can connect to slave jenkins docker image
RUN apt-get install -y openssh-server
RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Create an user named jenkins with admin privileges
RUN adduser --quiet jenkins
RUN adduser jenkins sudo

# Set password for the jenkins user as jenkins
RUN echo "jenkins:jenkins" | chpasswd

# Create Maven Local Repository directory and ensure jenkins user is the owner
RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/.m2/
COPY settings.xml /home/jenkins/.m2/

RUN mkdir -p /home/jenkins/workspace/DockerSlave
RUN chown -R jenkins:jenkins /home/jenkins/workspace/DockerSlave

# Create a project directory volume mount point inside the container 
RUN mkdir -p /home/jenkins/workspace/HelloDevOps
RUN chown -R jenkins:jenkins /home/jenkins/workspace/HelloDevOps
COPY . /home/jenkins/workspace/HelloDevOps

# Create a directory inside docker container for mounting your host machine JAVA_HOME 
RUN mkdir -p /usr/lib/jvm/java-8-openjdk-amd64
RUN chown -R jenkins:jenkins /usr/lib/jvm/java-8-openjdk-amd64

# Create a directory inside docker continer if you prefer mounting your host machine M3_HOME
RUN mkdir -p /usr/share/maven
RUN chown -R jenkins:jenkins /usr/share/maven

#Install maven inside docker container
RUN apt-get update && apt-get install -y maven

# Open SSH Port for jenkins master to ssh into this slave machine
EXPOSE 22

# Lauch SSH Server once the container is booted as a daemon
CMD ["/usr/sbin/sshd", "-D"]
