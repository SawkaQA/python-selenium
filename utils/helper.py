import json
import allure


class Helper:

    def attach_response(self, response):
        result = json.dumps(response, indent=4)
        allure.attach(
            body=result,
            name="API Response",
            attachment_type=allure.attachment_type.JSON
        )


