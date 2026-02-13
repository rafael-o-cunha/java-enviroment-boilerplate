FROM ubuntu:22.04

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=devuser

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven \
    git \
    curl \
    vim \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
    && useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash ${USER_NAME}

RUN mkdir -p /home/${USER_NAME}/.m2 \
    && chown -R ${USER_ID}:${GROUP_ID} /home/${USER_NAME}

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

USER ${USER_NAME}
WORKDIR /project

CMD ["bash"]
