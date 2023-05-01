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
        return_tensors = "pt"
    )

    # for name, parameter in classifier.named_parameters():
    #         if not name.startswith("bert"):
    #             print(parameter, "나중 ")
    #             break

    print(tokens)
    # result, attention = classifier(tokens)
    # last_attention = torch.mean(attention[-1], dim = 1).squeeze()

    detokenized = tokenizer.decode(tokens['input_ids'].squeeze())
    print(detokenized)
    # pd.DataFrame(last_attention).to_excel("temp.xlsx")
    # return { "result " : result.detach().squeeze().numpy().tolist()}

@router.post("/test")
async def junghee_test(string_model : StringModel):
    return { "result " : [0.1, 0.2, 0.3, 0.4]}

    