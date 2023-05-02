from fastapi import APIRouter
from model import ReferenceInputModel, SentenceModel, PhoneCallModel
from classifier.model import model as classifier
from classifier.model import pipeline
import torch
from torch.cuda import is_available
from transformers import DistilBertTokenizer

import pandas as pd

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")
device = "cuda" if is_available else "cpu"
softmax = torch.nn.Softmax(dim = 0)
session_store = dict()

@router.post("", response_model = PhoneCallModel)
async def classify_text(input_model : ReferenceInputModel):
    """
    결과 없을 때도 고려해야 한다... 
    """

    text = input_model.text
    is_finish = input_model.isFinish
    session_id = input_model.sessionId

    # classification using bayesian classifier
    label, label_probs, word_probs = pipeline.forward(text)

    # 가장 확률이 높은 단어 추출
    words, probs = zip(*word_probs)
    probs = softmax(torch.FloatTensor(probs))

    best_prob_idx = torch.argmax(probs)

    best_word = words[best_prob_idx]
    best_prob = probs[best_prob_idx].item()

    sentence_model = {
        "sentCategory" : label,
        "sentCategoryScore" : label_probs[label],
        "sentKeyword" : best_word,
        "keywordScore" : best_prob,
        "sentence" : text
    }

    # 세션 별 결과 저장

    has_session = session_store.get(session_id)

    if not has_session:
        session_store[session_id] = []

    session_store[session_id].append(sentence_model)

    # 결과값 반환

    phone_call_model = {
        "totalCategory" : 1 if is_finish else -1, # temporary value
        "totalCategoryScore" : 0.9 if is_finish else -1, # temporay value
        "results" : session_store[session_id].copy() if is_finish else [sentence_model] # temporary value
    }

    if is_finish:
        del session_store[session_id]

    return phone_call_model

    """ 여기 밑으로 살려야 한다. """

    # # tokenize
    # tokens = tokenizer(
    #     text = text,
    #     add_special_tokens = True,
    #     truncation = True,
    #     max_length = 512,
    #     return_tensors = "pt"
    # )

    # print(tokens)
    # result, attention = classifier(tokens)
    # last_attention = torch.mean(attention[-1], dim = 1).squeeze()

    # detokenized = [tokenizer.decode(token) for token in tokens['input_ids'].squeeze()]
    # print(detokenized)

    # pd.DataFrame(last_attention, columns= detokenized).to_excel(f"hi.xlsx")
    
    # return { "result" : result.detach().squeeze().numpy().tolist()}

    """ 여기 위로 살려야 한다. """

@router.post("/test")
async def junghee_test(input_model : ReferenceInputModel):
    return { "result" : [0.1, 0.2, 0.3, 0.4]}

    