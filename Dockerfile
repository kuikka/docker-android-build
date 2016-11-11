FROM ubuntu:trusty

# Update packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

# Add java ppa repo
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

RUN apt-get update

# Accept oracle licenses
RUN echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# Install javas
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-java6-installer oracle-java7-installer oracle-java8-installer

# Set java8 as default
RUN update-java-alternatives -s java-8-oracle

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV JAVA6_HOME /usr/lib/jvm/java-6-oracle
ENV JAVA7_HOME /usr/lib/jvm/java-7-oracle
ENV JAVA8_HOME /usr/lib/jvm/java-8-oracle

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq curl

RUN curl -o android-sdk_r24.4.1-linux.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN tar xf android-sdk_r24.4.1-linux.tgz
RUN rm -f android-sdk_r24.4.1-linux.tgz

ENV ANDROID_HOME=$PWD/android-sdk-linux
RUN echo "y"|$ANDROID_HOME/tools/android update sdk --no-ui --all --filter tools,platform-tools,build-tools-25.0.0,android-23,android-18,build-tools-24.0.1
RUN mkdir -p $ANDROID_HOME/licenses
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license

