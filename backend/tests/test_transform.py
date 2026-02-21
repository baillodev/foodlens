import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from routers.analyze import transform_results


SPOONACULAR_RESPONSE = {
    "status": "success",
    "category": {"name": "pizza", "probability": 0.85},
    "nutrition": {
        "recipesUsed": 10,
        "calories": {"value": 389.0, "unit": "calories"},
        "fat": {"value": 20.0, "unit": "g"},
        "protein": {"value": 16.0, "unit": "g"},
        "carbs": {"value": 33.0, "unit": "g"},
    },
    "recipes": [],
}


def test_transform_valid_response():
    is_food, foods, total = transform_results(SPOONACULAR_RESPONSE)
    assert is_food is True
    assert len(foods) == 1
    assert foods[0].name == "pizza"
    assert foods[0].confidence_score == 85.0
    assert total.calories == 389.0
    assert total.protein == 16.0
    assert total.total_carbs == 33.0
    assert total.total_fat == 20.0


def test_transform_empty_category():
    raw = {"category": {"name": "", "probability": 0}, "nutrition": {}}
    is_food, foods, total = transform_results(raw)
    assert is_food is False
    assert foods == []
    assert total.calories == 0


def test_transform_low_probability():
    raw = {
        "category": {"name": "unknown", "probability": 0.0005},
        "nutrition": {
            "calories": {"value": 100},
            "protein": {"value": 5},
            "carbs": {"value": 10},
            "fat": {"value": 3},
        },
    }
    is_food, foods, total = transform_results(raw)
    assert is_food is False


def test_transform_missing_nutrition_fields():
    raw = {
        "category": {"name": "salad", "probability": 0.7},
        "nutrition": {},
    }
    is_food, foods, total = transform_results(raw)
    assert is_food is True
    assert foods[0].name == "salad"
    assert total.calories == 0
    assert total.protein == 0


def test_transform_empty_dict():
    is_food, foods, total = transform_results({})
    assert is_food is False
    assert foods == []
