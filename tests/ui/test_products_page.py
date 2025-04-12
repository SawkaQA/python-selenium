from conftest import product_page, driver, base_url


class TestProductsPage:

    def test_open(self, product_page):
        product_page.open()
        assert  product_page.driver.title == "DEMOQA", f"Ошибка title {product_page.driver.title}"