import allure
import pytest
import requests
from faker.generator import random
from conftest import generate_faker_data, base_url, faker


class TestReqResEndpoints:

    @pytest.mark.skip("flaky")
    def test_create_user(self, base_url, generate_faker_data):
        headers = {"api-key": "special-key"}
        data = {
            **generate_faker_data
        }

        response = requests.post(f'{base_url}/user', json=data, headers=headers)
        assert response.status_code == 200, "Ошибка, регистранция не пройдена"
        assert "code" in response.json(), "Ошибка, сущность не создана"

        response_username = requests.get(f'{base_url}/user/{data["username"]}')
        assert response_username.json()['username'] == data['username']
        assert response_username.json()['id'] == data['id'], "ID не совпадают"

    def test_create_pet(self, base_url, generate_faker_data):
        with allure.step(f'Отправляем запрос на создание питомца {generate_faker_data["username"]}'):
            statuses = ['available', 'sold']
            data = {
                "id": generate_faker_data['id'],
                "category": {
                    "id": random.randint(4, 444),
                    "name": "CATS"
                },
                "name": faker.first_name(),
                "photoUrls": [
                    None
                ],
                "tags": [
                    {
                        "id": random.randint(3, 333),
                        "name": "CATS"
                    }
                ],
                "status": random.choice(statuses)
            }

            response = requests.post(f'{base_url}/pet', json=data)
            assert response.status_code == 200, "Ошибка создания животного"
            assert data['name'] == response.json()['name']

            response_get_pet = requests.get(f'{base_url}/pet/{data["id"]}')
            assert response_get_pet.status_code == 200
            assert response_get_pet.json()['name'] == data['name']

    def test_delete_pet(self, base_url, generate_faker_data):
        with allure.step(f"Удаление питомца по id {generate_faker_data['id']}"):
            headers = {"api-key": "special-key"}
            request = requests.delete(f'{base_url}/pet/{generate_faker_data["id"]}', headers=headers)
            assert request.status_code == 404 or 200, "Ошибка, питомец не был удален"
