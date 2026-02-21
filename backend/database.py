import os

import aiosqlite

DATABASE_PATH = os.path.join(os.path.dirname(__file__), "foodlens.db")


async def get_db():
    db = await aiosqlite.connect(DATABASE_PATH)
    db.row_factory = aiosqlite.Row
    try:
        yield db
    finally:
        await db.close()


async def init_db():
    async with aiosqlite.connect(DATABASE_PATH) as db:
        await db.execute("""
            CREATE TABLE IF NOT EXISTS analyses (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                image_url TEXT NOT NULL,
                is_food BOOLEAN NOT NULL DEFAULT 1,
                raw_response TEXT,
                analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        await db.execute("""
            CREATE TABLE IF NOT EXISTS food_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                analysis_id INTEGER NOT NULL,
                name TEXT NOT NULL,
                food_group TEXT,
                confidence_score REAL,
                calories REAL,
                protein REAL,
                total_carbs REAL,
                total_fat REAL,
                serving_weight REAL,
                serving_unit TEXT,
                FOREIGN KEY (analysis_id) REFERENCES analyses(id)
            )
        """)
        await db.commit()
