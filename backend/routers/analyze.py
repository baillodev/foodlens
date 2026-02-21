import json
from datetime import datetime

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile

from database import get_db
from models import AnalysisResponse, FoodItemOut, NutritionOut
from services import cloudinary_service, history_service, rapidapi_service

router = APIRouter()

MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB


def transform_results(raw: dict) -> tuple[list[FoodItemOut], NutritionOut]:
    foods = []
    for group in raw.get("results", []):
        group_name = group.get("group", "")
        for item in group.get("items", []):
            nutrition = item.get("nutrition", {})
            serving_sizes = item.get("servingSizes", [])
            serving = serving_sizes[0] if serving_sizes else {}

            foods.append(
                FoodItemOut(
                    name=item.get("name", ""),
                    group=group_name,
                    confidence_score=item.get("score", 0),
                    nutrition=NutritionOut(
                        calories=nutrition.get("calories", 0),
                        protein=nutrition.get("protein", 0),
                        total_carbs=nutrition.get("totalCarbs", 0),
                        total_fat=nutrition.get("totalFat", 0),
                    ),
                    serving_weight=serving.get("servingWeight"),
                    serving_unit=serving.get("unit"),
                )
            )

    total_nutrition = NutritionOut(
        calories=sum(f.nutrition.calories for f in foods),
        protein=sum(f.nutrition.protein for f in foods),
        total_carbs=sum(f.nutrition.total_carbs for f in foods),
        total_fat=sum(f.nutrition.total_fat for f in foods),
    )

    return foods, total_nutrition


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

    raw_result = await rapidapi_service.analyze_food_image(image_url)

    is_food = raw_result.get("is_food", False)
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

    foods, total_nutrition = transform_results(raw_result)

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
