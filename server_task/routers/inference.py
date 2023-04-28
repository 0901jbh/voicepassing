from fastapi import APIRouter
from model import StringModel
from classifier.model import model as classifier

router = APIRouter(
    prefix="/inference"
)

@router.post("/")
async def classify_text(string_model : StringModel):
    text = string_model.text
    result = classifier.forward(text)

    return result
    