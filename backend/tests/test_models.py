import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from models import AnalysisResponse, FoodItemOut, HistoryEntry, NutritionOut


def test_nutrition_out_creation():
    n = NutritionOut(calories=250, protein=10, total_carbs=30, total_fat=8)
    assert n.calories == 250
    assert n.protein == 10
    assert n.total_carbs == 30
    assert n.total_fat == 8


def test_food_item_out_defaults():
    food = FoodItemOut(
        name="pizza",
        group="pizza",
        confidence_score=85.0,
        nutrition=NutritionOut(calories=300, protein=12, total_carbs=35, total_fat=14),
    )
    assert food.serving_weight is None
    assert food.serving_unit is None


def test_food_item_out_with_serving():
    food = FoodItemOut(
        name="rice",
        group="grain",
        confidence_score=90.0,
        nutrition=NutritionOut(calories=200, protein=4, total_carbs=45, total_fat=1),
        serving_weight=150.0,
        serving_unit="g",
    )
    assert food.serving_weight == 150.0
    assert food.serving_unit == "g"


def test_history_entry_creation():
    entry = HistoryEntry(
        id=1,
        image_url="https://example.com/img.jpg",
        food_summary="pizza, salad",
        total_calories=450.0,
        analyzed_at="2026-01-01T12:00:00",
    )
    assert entry.id == 1
    assert entry.food_summary == "pizza, salad"
    assert entry.total_calories == 450.0


def test_analysis_response_without_id():
    resp = AnalysisResponse(
        is_food=True,
        image_url="https://example.com/img.jpg",
        foods=[],
        total_nutrition=NutritionOut(
            calories=0, protein=0, total_carbs=0, total_fat=0
        ),
        analyzed_at="2026-01-01T12:00:00",
    )
    assert resp.id is None
    assert resp.is_food is True
    assert resp.foods == []
