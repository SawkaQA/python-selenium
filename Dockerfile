FROM python:3.12-alpine

# Установка системных зависимостей
RUN apk update && \
    apk add --no-cache \
    chromium \
    chromium-chromedriver \
    openjdk11-jre-headless \
    curl \
    tar \
    tzdata \
    git \
    && rm -rf /var/cache/apk/*

# Установка Allure (оптимизированная)
RUN curl -Lo allure-2.33.0.tgz https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.33.0/allure-commandline-2.33.0.tgz \
    && tar -zxvf allure-2.33.0.tgz -C /opt/ \
    && ln -sf /opt/allure-2.33.0/bin/allure /usr/bin/allure \
    && rm allure-2.33.0.tgz \
    && allure --version

RUN echo "Allure version: $(allure --version)" && \
    echo "Java version: $(java -version 2>&1 | head -n 1)" && \
    echo "Chromium version: $(chromium-browser --version)"

WORKDIR /usr/workspace

# Оптимизация кэширования зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Копирование проекта (с исключениями через .dockerignore)
COPY . .