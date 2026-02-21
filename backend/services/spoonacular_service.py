import httpx

from config import settings

SPOONACULAR_BASE_URL = "https://api.spoonacular.com"


async def analyze_food_image(image_url: str) -> dict:
    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.get(
            f"{SPOONACULAR_BASE_URL}/food/images/analyze",
            params={
                "imageUrl": image_url,
                "apiKey": settings.SPOONACULAR_API_KEY,
            },
        )
        response.raise_for_status()
        return response.json()
