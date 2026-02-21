from fastapi import APIRouter, Depends, HTTPException

from database import get_db
from models import HistoryDetail, HistoryEntry
from services import history_service

router = APIRouter()


@router.get("/history", response_model=list[HistoryEntry])
async def list_history(db=Depends(get_db)):
    return await history_service.get_all_analyses(db)


@router.get("/history/{analysis_id}", response_model=HistoryDetail)
async def get_history_detail(analysis_id: int, db=Depends(get_db)):
    result = await history_service.get_analysis_detail(db, analysis_id)
    if not result:
        raise HTTPException(status_code=404, detail="Analyse non trouvee")
    return result
