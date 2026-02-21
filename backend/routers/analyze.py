import json
from datetime import datetime

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile

from database import get_db
from models import AnalysisResponse, FoodItemOut, NutritionOut
from services import cloudinary_service, spoonacular_service

router = APIRouter()

MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB


def transform_results(raw: dict) -> tuple[bool, list[FoodItemOut], NutritionOut]:
    category = raw.get("category", {})
    nutrition = raw.get("nutrition", {})

    food_name = category.get("name", "")
    probability = category.get("probability", 0) * 100

    if not food_name or probability < 0.1:
        return False, [], NutritionOut(
            calories=0, protein=0, total_carbs=0, total_fat=0
        )

    calories = nutrition.get("calories", {}).get("value", 0)
    protein = nutrition.get("protein", {}).get("value", 0)
    carbs = nutrition.get("carbs", {}).get("value", 0)
    fat = nutrition.get("fat", {}).get("value", 0)

    food_nutrition = NutritionOut(
        calories=calories,
        protein=protein,
        total_carbs=carbs,
        total_fat=fat,
    )

    food = FoodItemOut(
        name=food_name,
        group=food_name,
        confidence_score=probability,
        nutrition=food_nutrition,
    )

    return True, [food], food_nutrition


@router.post("/analyze", response_model=AnalysisResponse)
async def analyze_food(
    file: UploadFile = File(...),
    db=Depends(get_db),
):
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(
            status_code=400, detail="Le fichier doit etre une image (JPEG, PNG)"
        )

    contents = await file.read()
    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=400, detail="L'image ne doit pas depasser 10 MB"
        )
    await file.seek(0)

    image_url = await cloudinary_service.upload_image(file)

    raw_result = await spoonacular_service.analyze_food_image(image_url)

    is_food, foods, total_nutrition = transform_results(raw_result)

    if not is_food:
        return AnalysisResponse(
            is_food=False,
            image_url=image_url,
            foods=[],
            total_nutrition=NutritionOut(
                calories=0, protein=0, total_carbs=0, total_fat=0
            ),
            analyzed_at=datetime.utcnow(),
        )

    from services import history_service

    analysis_id = await history_service.save_analysis(
        db, image_url, is_food, json.dumps(raw_result), foods
    )

    return AnalysisResponse(
        id=analysis_id,
        is_food=is_food,
        image_url=image_url,
        foods=foods,
        total_nutrition=total_nutrition,
        analyzed_at=datetime.utcnow(),
    )
