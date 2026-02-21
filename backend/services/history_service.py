import json

import aiosqlite

from models import (
    AnalysisResponse,
    FoodItemOut,
    HistoryDetail,
    HistoryEntry,
    NutritionOut,
)


async def save_analysis(
    db: aiosqlite.Connection,
    image_url: str,
    is_food: bool,
    raw_response: str,
    foods: list[FoodItemOut],
) -> int:
    cursor = await db.execute(
        "INSERT INTO analyses (image_url, is_food, raw_response) VALUES (?, ?, ?)",
        (image_url, is_food, raw_response),
    )
    analysis_id = cursor.lastrowid

    for food in foods:
        await db.execute(
            """INSERT INTO food_items
               (analysis_id, name, food_group, confidence_score,
                calories, protein, total_carbs, total_fat,
                serving_weight, serving_unit)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
            (
                analysis_id,
                food.name,
                food.group,
                food.confidence_score,
                food.nutrition.calories,
                food.nutrition.protein,
                food.nutrition.total_carbs,
                food.nutrition.total_fat,
                food.serving_weight,
                food.serving_unit,
            ),
        )

    await db.commit()
    return analysis_id


async def get_all_analyses(db: aiosqlite.Connection) -> list[HistoryEntry]:
    cursor = await db.execute("""
        SELECT
            a.id,
            a.image_url,
            a.analyzed_at,
            GROUP_CONCAT(fi.name, ', ') as food_summary,
            COALESCE(SUM(fi.calories), 0) as total_calories
        FROM analyses a
        LEFT JOIN food_items fi ON fi.analysis_id = a.id
        WHERE a.is_food = 1
        GROUP BY a.id
        ORDER BY a.analyzed_at DESC
    """)
    rows = await cursor.fetchall()
    return [
        HistoryEntry(
            id=row[0],
            image_url=row[1],
            analyzed_at=row[2],
            food_summary=row[3] or "",
            total_calories=row[4],
        )
        for row in rows
    ]


async def get_analysis_detail(
    db: aiosqlite.Connection, analysis_id: int
) -> HistoryDetail | None:
    cursor = await db.execute(
        "SELECT id, image_url, is_food, analyzed_at FROM analyses WHERE id = ?",
        (analysis_id,),
    )
    analysis = await cursor.fetchone()
    if not analysis:
        return None

    cursor = await db.execute(
        """SELECT name, food_group, confidence_score,
                  calories, protein, total_carbs, total_fat,
                  serving_weight, serving_unit
           FROM food_items WHERE analysis_id = ?""",
        (analysis_id,),
    )
    items = await cursor.fetchall()

    foods = [
        FoodItemOut(
            name=item[0],
            group=item[1] or "",
            confidence_score=item[2] or 0,
            nutrition=NutritionOut(
                calories=item[3] or 0,
                protein=item[4] or 0,
                total_carbs=item[5] or 0,
                total_fat=item[6] or 0,
            ),
            serving_weight=item[7],
            serving_unit=item[8],
        )
        for item in items
    ]

    total_nutrition = NutritionOut(
        calories=sum(f.nutrition.calories for f in foods),
        protein=sum(f.nutrition.protein for f in foods),
        total_carbs=sum(f.nutrition.total_carbs for f in foods),
        total_fat=sum(f.nutrition.total_fat for f in foods),
    )

    return HistoryDetail(
        id=analysis[0],
        image_url=analysis[1],
        is_food=bool(analysis[2]),
        analyzed_at=analysis[3],
        foods=foods,
        total_nutrition=total_nutrition,
    )
