FROM ubuntu 
MAINTAINER Jeganathan Swaminathan <jegan@tektutor.org>

# Let's ensure that all package repositories are up to date 
RUN apt-get update

# We need ssh server so that Jenkins Master can connect to slave jenkins docker image
RUN apt-get install -y openssh-server
RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

RUN adduser --quiet jenkins
RUN adduser jenkins sudo

# Set password for the jenkins user
RUN echo "jenkins:jenkins" | chpasswd

# Create Maven Local Repository directory
RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/.m2/

RUN mkdir -p /home/jenkins/workspace/HelloDevOps
RUN chown -R jenkins:jenkins /home/jenkins/workspace/HelloDevOps
RUN mkdir -p /usr/lib/jvm/java-8-openjdk-amd64
RUN chown -R jenkins:jenkins /usr/lib/jvm/java-8-openjdk-amd64
RUN mkdir -p /usr/share/maven
RUN chown -R jenkins:jenkins /usr/share/maven

RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN export M2_HOME=/usr/share/maven
RUN export PATH=$JAVA_HOME/bin:/$M2_HOME/bin:$PATH

# Open SSH Port for jenkins master to ssh into this slave machine
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
