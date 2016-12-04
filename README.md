# devops-slave

This is a simple docker jenkins-slave image based on Ubuntu official image.  This Dockerfile will setup the following empty folders.

1. Java directory
2. Maven directory 
3. Maven Local Repository 
4. Project directory

Though copying source code and installing all the necessary tools and softwares are an option, in order to reduce the Jenkins build time,
I prefer mounting the software folders from my host machine inside the container. 

Hence, while running the tektutorjegan/devops-slave docker image, the respective tools from their host machines can be mounted inside 
the empty folders created as mount points so that the image size can be kept as smaller as possible at the same it helps bring down 
the build time drastically.

For example:-

docker run -v /usr/lib/jvm/java-8-openjdk-amd64:/usr/lib/jvm/java-8-openjdk-amd64 
           -v /home/jegan/Trainings/DevOpsWithDocker/tektutor-hello-app:/home/jenkins/workspace/HelloDevOps
           -v /home/jegan/.m2:/home/jenkins/.m2
           -it tektutorjegan/devops-slave bash
           
As this docker image will install maven automatically, I haven't mounted Maven directory, however mounting your host machine
.m2 folder inside the home directory of jenkins user .m2 container helps avoid the devops-build downloading maven plugins everytime.

Hope this image helps you!
