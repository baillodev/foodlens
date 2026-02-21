from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    RAPIDAPI_KEY: str
    RAPIDAPI_HOST: str = (
        "ai-food-calorie-counter-nutrition-analyzer-from-photo.p.rapidapi.com"
    )
    CLOUDINARY_CLOUD_NAME: str
    CLOUDINARY_API_KEY: str
    CLOUDINARY_API_SECRET: str

    class Config:
        env_file = ".env"


settings = Settings()
