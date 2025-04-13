from conftest import product_page, driver, base_url


class TestProductsPage:

    def test_open(self, product_page):
        product_page.open('DEMOQAa')
        product_page.check_link_elements()
