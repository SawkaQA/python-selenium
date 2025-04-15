import pytest
from pages.product_page import ProductPage

class BaseTest:

    product_page: ProductPage

    @pytest.fixture(autouse=True)
    def setup(self, request, driver):

        request.cls.driver = driver
        request.cls.product_page = ProductPage(driver)