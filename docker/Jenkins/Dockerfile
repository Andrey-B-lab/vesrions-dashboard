FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y docker.io python3 python3-pip curl gnupg jq postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    usermod -aG docker jenkins

USER jenkins
