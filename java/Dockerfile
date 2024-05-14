# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ecovoyage/docker:20250501

FROM --platform=$BUILDPLATFORM $BASE_IMAGE as java

USER root

COPY --chown=$MAMBA_USER:$MAMBA_USER apt.txt /opt/conda/environments/apt.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-java apt-get update && xargs apt-get install -y < /opt/conda/environments/apt.txt

ENV JAVA_HOME /opt/java/openjdk
ENV MAVEN_HOME /opt/maven
ENV PATH $JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

RUN mkdir -p "$JAVA_HOME" \
    && cd /tmp \
    && curl -L -o openjdk-21.tar.gz "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz" \
    && tar --extract --file openjdk-21.tar.gz --directory "$JAVA_HOME" --strip-components 1 \
    && rm openjdk-21.tar.gz

RUN mkdir -p "$MAVEN_HOME" \
    && curl -L -o /tmp/maven.tar.gz "https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz" \
    && tar --extract --file /tmp/maven.tar.gz --directory "$MAVEN_HOME" --strip-components 1 \
    && rm /tmp/maven.tar.gz