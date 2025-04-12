FROM python:3.12.0a4-alpine3.17

# Установка базовых зависимостей
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    tzdata \
    openjdk11-jre-headless \
    curl \
    tar \
    bash \
    && rm -rf /var/cache/apk/*

# Установка Allure
ENV ALLURE_VERSION=2.33.0
RUN mkdir -p /opt/allure \
    && curl -o allure-${ALLURE_VERSION}.tgz -Ls \
       "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz" \
    && tar -zxvf allure-${ALLURE_VERSION}.tgz -C /opt/allure --strip-components=1 \
    && rm allure-${ALLURE_VERSION}.tgz \
    && ln -s /opt/allure/bin/allure /usr/local/bin/allure

# Создание рабочей директории
RUN mkdir -p /usr/workspace
WORKDIR /usr/workspace

# Установка Python-зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Настройка окружения
ENV ALLURE_NO_ANALYTICS=1 \
    PYTHONUNBUFFERED=1 \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    UID=1000 \
    GID=1000

# Копирование файлов проекта (без изменения владельца)
COPY . .

# Финализация прав доступа
RUN mkdir -p /usr/workspace/allure-report \
    && mkdir -p /usr/workspace/allure-results \
    && chmod -R 777 /usr/workspace/allure-report \
    && chmod -R 777 /usr/workspace/allure-results

# Запуск от текущего пользователя (будет переопределено в docker-compose)
CMD ["sh", "-c", "pytest -sv --alluredir=allure-results && allure generate allure-results --clean -o allure-report --no-perms || echo 'Test execution completed'"]