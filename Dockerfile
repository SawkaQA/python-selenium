FROM python:3.12.0a4-alpine3.17

# Install Chromium and Chromedriver
RUN apk update && \
    apk add --no-cache chromium chromium-chromedriver tzdata

# Install Java and dependencies for Allure
RUN apk update && \
    apk add --no-cache openjdk11-jre-headless curl tar && \
    rm -f /usr/bin/allure && \
    rm -rf /opt/allure-* && \
    curl -o allure-2.33.0.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.33.0/allure-commandline-2.33.0.tgz && \
    tar -zxvf allure-2.33.0.tgz -C /opt/ && \
    ln -s /opt/allure-2.33.0/bin/allure /usr/bin/allure && \
    rm allure-2.33.0.tgz

WORKDIR /usr/workspace

# Copy the dependencies file to the working directory
COPY ./requirements.txt /usr/workspace

# Install Python dependencies
RUN pip3 install -r requirements.txt