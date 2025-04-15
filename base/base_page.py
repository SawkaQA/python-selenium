import allure
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class BasePage:

    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10, poll_frequency=1)


    def open(self, opened_url_title):
        with allure.step(f"Открываем {self.URL}"):
            self.driver.get(self.URL)
            assert self.driver.title == opened_url_title, f"Ошибка title {self.driver.title}"


    def elem_is_clickable(self, locator):
        return self.wait.until(EC.element_to_be_clickable(locator))

