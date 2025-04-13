from base.base_page import BasePage
from links.links import Links


class ProductPage(BasePage):

    URL = Links.HOME_URL
    ELEMENTS_LINK = ("xpath", "//h5[text()='Elements']")


    def check_link_elements(self):
        link = self.elem_is_clickable(self.ELEMENTS_LINK)
        assert link.text == "Elements", f"Ошибка текста ссылки {link.text}"