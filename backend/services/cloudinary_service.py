import asyncio
from functools import partial

import cloudinary
import cloudinary.uploader
from fastapi import UploadFile

from config import settings

cloudinary.config(
    cloud_name=settings.CLOUDINARY_CLOUD_NAME,
    api_key=settings.CLOUDINARY_API_KEY,
    api_secret=settings.CLOUDINARY_API_SECRET,
)


async def upload_image(file: UploadFile) -> str:
    loop = asyncio.get_event_loop()
    contents = await file.read()
    result = await loop.run_in_executor(
        None,
        partial(
            cloudinary.uploader.upload,
            contents,
            folder="foodlens",
            resource_type="image",
        ),
    )
    return result["secure_url"]
