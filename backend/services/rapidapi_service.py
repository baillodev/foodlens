import httpx

from config import settings


async def analyze_food_image(image_url: str) -> dict:
    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.get(
            f"https://{settings.RAPIDAPI_HOST}/foodanalyz.php",
            params={"img": image_url},
            headers={
                "x-rapidapi-host": settings.RAPIDAPI_HOST,
                "x-rapidapi-key": settings.RAPIDAPI_KEY,
            },
        )
        response.raise_for_status()
        return response.json()
