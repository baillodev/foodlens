from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class NutritionOut(BaseModel):
    calories: float
    protein: float
    total_carbs: float
    total_fat: float


class FoodItemOut(BaseModel):
    name: str
    group: str
    confidence_score: float
    nutrition: NutritionOut
    serving_weight: Optional[float] = None
    serving_unit: Optional[str] = None


class AnalysisResponse(BaseModel):
    id: Optional[int] = None
    is_food: bool
    image_url: str
    foods: list[FoodItemOut]
    total_nutrition: NutritionOut
    analyzed_at: datetime


class HistoryEntry(BaseModel):
    id: int
    image_url: str
    food_summary: str
    total_calories: float
    analyzed_at: datetime


class HistoryDetail(AnalysisResponse):
    pass
