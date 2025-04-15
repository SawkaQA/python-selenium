from base.base_test import BaseTest
from conftest import product_page, driver, base_url


class TestProductsPage(BaseTest):

    def test_open(self):
        self.product_page.open('DEMOQA')
        self.product_page.check_link_elements()
