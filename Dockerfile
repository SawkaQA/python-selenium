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
    xvfb \
    dbus \
    fontconfig \
    freetype \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Установка Allure
RUN curl -Lo allure-2.33.0.tgz https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.33.0/allure-commandline-2.33.0.tgz \
    && tar -zxvf allure-2.33.0.tgz -C /opt/ \
    && ln -sf /opt/allure-2.33.0/bin/allure /usr/bin/allure \
    && rm allure-2.33.0.tgz

WORKDIR /usr/workspace

# Копируем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь проект
COPY . .

# Переменные окружения для Chrome
ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    DISPLAY=:99 \
    SCREEN_RESOLUTION=1920x1080x24