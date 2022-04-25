#
# Minecraft Bedrock Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

MAINTAINER hihouhou < hihouhou@hihouhou.com >

ENV MINECRAFT_VERSION 18.30.04

# Update & install packages for installing minecraft
RUN apt-get update && \
    apt-get install -y apt-transport-https software-properties-common gnupg wget unzip

# Install openjdk
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    apt update && \
    apt install -y openjdk-17-jdk

#Create huginn user
RUN adduser --disabled-login --gecos 'Minecraft' minecraft

WORKDIR /opt/minecraft

COPY eula.txt /opt/minecraft/eula.txt
COPY allowlist.json /opt/minecraft/allowlist.json
COPY server.properties /opt/minecraft/server.properties

RUN chown -R minecraft: /opt/minecraft

USER minecraft

#Install and configure minecraft
#RUN wget https://launcher.mojang.com/${MINECRAFT_VERSION}/server.jar
RUN wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.${MINECRAFT_VERSION}.zip && \
    unzip -n bedrock-server-1.${MINECRAFT_VERSION}.zip && \
    rm -rf bedrock-server-1.${MINECRAFT_VERSION}.zip

EXPOSE 25565

CMD ["./bedrock_server"]
