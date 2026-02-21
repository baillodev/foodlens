import sys
import os
from unittest.mock import AsyncMock, patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

import pytest
from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health_endpoint():
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"


def test_analyze_rejects_non_image():
    response = client.post(
        "/api/v1/analyze",
        files={"file": ("test.txt", b"not an image", "text/plain")},
    )
    assert response.status_code == 400
    assert "image" in response.json()["detail"].lower()


def test_analyze_rejects_large_file():
    large_content = b"\xff\xd8\xff\xe0" + (b"\x00" * (11 * 1024 * 1024))
    response = client.post(
        "/api/v1/analyze",
        files={"file": ("big.jpg", large_content, "image/jpeg")},
    )
    assert response.status_code == 400
    assert "10 MB" in response.json()["detail"]


MOCK_SPOONACULAR = {
    "status": "success",
    "category": {"name": "burger", "probability": 0.92},
    "nutrition": {
        "recipesUsed": 15,
        "calories": {"value": 540.0, "unit": "calories"},
        "fat": {"value": 28.0, "unit": "g"},
        "protein": {"value": 25.0, "unit": "g"},
        "carbs": {"value": 45.0, "unit": "g"},
    },
    "recipes": [],
}


@patch("routers.analyze.spoonacular_service.analyze_food_image", new_callable=AsyncMock)
@patch("routers.analyze.cloudinary_service.upload_image", new_callable=AsyncMock)
def test_analyze_success(mock_upload, mock_spoonacular):
    mock_upload.return_value = "https://res.cloudinary.com/test/image.jpg"
    mock_spoonacular.return_value = MOCK_SPOONACULAR

    small_jpeg = b"\xff\xd8\xff\xe0" + b"\x00" * 100
    response = client.post(
        "/api/v1/analyze",
        files={"file": ("food.jpg", small_jpeg, "image/jpeg")},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["is_food"] is True
    assert len(data["foods"]) == 1
    assert data["foods"][0]["name"] == "burger"
    assert data["total_nutrition"]["calories"] == 540.0
    assert data["total_nutrition"]["protein"] == 25.0


def test_history_empty():
    response = client.get("/api/v1/history")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_history_detail_not_found():
    response = client.get("/api/v1/history/99999")
    assert response.status_code == 404
