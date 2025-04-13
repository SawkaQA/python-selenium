import uuid
import pytest
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from faker import Faker
from pages.product_page import ProductPage

faker = Faker('ru-RU')

@pytest.fixture
def driver():
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--headless=new")  # Новый headless-режим
    options.add_argument(f"--user-data-dir=/tmp/chrome-profile-{str(uuid.uuid4())}")
    driver = webdriver.Chrome(options=options)
    driver.maximize_window()
    yield driver
    driver.quit()

@pytest.fixture()
def product_page(driver):
    return ProductPage(driver)

@pytest.fixture()
def base_url():
    return "https://petstore.swagger.io/v2"

@pytest.fixture()
def generate_faker_data():
    return {
        "id": 2,
        "username": faker.user_name(),
        "firstname": faker.first_name(),
        "lastname": faker.last_name(),
        "email": faker.email(),
        "password": faker.password(length=8),
        "phone": faker.phone_number()
    }