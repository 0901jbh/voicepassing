from fastapi import APIRouter
from model import StringModel
from classifier.model import model as classifier
from torch.cuda import is_available
from transformers import DistilBertTokenizer

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-uncased")
device = "cuda" if is_available else "cpu"

@router.post("/")
async def classify_text(string_model : StringModel):
    text = string_model.text

    # tokenize
    tokens = tokenizer(
        text = text,
        add_special_tokens = True,
        max_length = 512,
        padding = "max_length",
        truncation = True,
        return_tensors = "pt"
    )

    result, attention = classifier(tokens)
    print(result)

    return { "result " : result.detach().squeeze().numpy().tolist()}

@router.post("/test")
async def junghee_test(string_model : StringModel):
    return { "result " : [0.1, 0.2, 0.3, 0.4]}

    