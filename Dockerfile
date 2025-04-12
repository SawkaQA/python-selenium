FROM python:3.12.0a4-alpine3.17

# Установка базовых зависимостей
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    tzdata \
    openjdk11-jre-headless \
    curl \
    tar \
    bash

# Установка Allure (с обработкой существующих файлов)
RUN mkdir -p /opt/allure && \
    curl -o allure-2.33.0.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.33.0/allure-commandline-2.33.0.tgz && \
    tar -zxvf allure-2.33.0.tgz -C /opt/allure --strip-components=1 && \
    rm -f /usr/bin/allure && \
    ln -s /opt/allure/bin/allure /usr/bin/allure && \
    rm allure-2.33.0.tgz

WORKDIR /usr/workspace

# Установка Python-зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копирование остальных файлов проекта
COPY . .