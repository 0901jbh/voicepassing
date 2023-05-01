from fastapi import APIRouter
from model import StringModel
from classifier.model import model as classifier
import torch
from torch.cuda import is_available
from transformers import DistilBertTokenizer

import pandas as pd

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")
device = "cuda" if is_available else "cpu"

@router.post("/")
async def classify_text(string_model : StringModel):
    text = string_model.text

    # tokenize
    tokens = tokenizer(
        text = text,
        add_special_tokens = True,
        truncation = True,
        max_length = 512,
        return_tensors = "pt"
    )

    print(tokens)
    result, attention = classifier(tokens)
    last_attention = attention[-1].squeeze()

    detokenized = [tokenizer.decode(token) for token in tokens['input_ids'].squeeze()]
    print(detokenized)

    # pd.DataFrame(temp, columns= detokenized).to_excel(f"hi.xlsx")
    
    return { "result " : result.detach().squeeze().numpy().tolist()}

@router.post("/test")
async def junghee_test(string_model : StringModel):
    return { "result " : [0.1, 0.2, 0.3, 0.4]}

    