from fastapi import APIRouter, Response, status
from model import ReferenceInputModel, SentenceModel, PhoneCallModel
from classifier.model import model as classifier
from classifier.model import pipeline
import torch
from torch.cuda import is_available
from transformers import DistilBertTokenizer
from utils import classify_phonecall

import pandas as pd

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")
device = "cuda" if is_available else "cpu"
softmax = torch.nn.Softmax(dim = 0)

session_store = dict()
prob_store = dict()

T = 36
THRESHOLD = 0.5

@router.post("", response_model = PhoneCallModel, status_code = 200)
async def classify_sentence(input_model : ReferenceInputModel, response : Response):

    text = input_model.text
    is_finish = input_model.isFinish
    session_id = input_model.sessionId

    # 1. BERT Classification

    ## 1.1. Tokenization
    tokens = tokenizer(
        text = text,
        add_special_tokens = True,
        truncation = True,
        max_length = 512,
        return_tensors = "pt"
    )

    output, attention = classifier(tokens)
    label_probs = torch.nn.functional.softmax(output.squeeze() / T)

    # attention = torch.mean(attention[-1], dim = 1).squeeze()
    # pd.DataFrame(attention, columns = ["<CLS>"] + tokenizer.tokenize(text) + ["<SEP>"]).to_excel("attention.xlsx")
    
    # 2. Bayesian Classification
    _, b_label_probs, word_probs = pipeline.forward(text)

    # 3. get result and save
    label_probs = (label_probs + torch.FloatTensor(b_label_probs)) / 2
    label = torch.argmax(label_probs, dim = 0).item()

    if not prob_store.get(session_id):
        prob_store[session_id] = []

    prob_store[session_id].append(label_probs.detach().cpu().numpy().tolist())

    ## 3.1. label 설정하기
    if label_probs[label] < THRESHOLD : # 일정 기준을 넘지 못하면, 다 혐의 없음
        label = 0

    # 4. 분기 1 : 혐의 없음 (분석을 했는데, 보이스피싱이 아닌 경우)
    if label == 0 and not is_finish:
        empty_phone_call_model = PhoneCallModel()
        response.status_code = 204
        return empty_phone_call_model
    
    # 5. 특정 키워드 추출하기

    word_probs = word_probs.as_list(label = label)
    words, probs = zip(*word_probs)

    probs = softmax(torch.FloatTensor(probs))
    best_prob_idx = torch.argmax(probs)
    best_word = words[best_prob_idx]
    best_prob = probs[best_prob_idx].item()

    sentence_model = SentenceModel(
        sentCategory = label,
        sentCategoryScore = label_probs[label],
        sentKeyword = best_word,
        keywordScore = best_prob,
        sentence = text
    )

    has_session = session_store.get(session_id)
    if not has_session:
        session_store[session_id] = []
    
    if label != 0:
        session_store[session_id].append(sentence_model)

    # 분기 2 : 혐의 있음, 통화 지속됨 (분석을 했는데, 보이스피싱에 해당하는 경우 + 통화가 안 끝났을 경우)
    if not is_finish:
        empty_phone_call_model = PhoneCallModel(results = [sentence_model])
        return empty_phone_call_model

    # 결과값 반환

    weighted_probs, call_label = classify_phonecall(prob_store.get(session_id))

    if call_label == 0:
        response.status_code = 204
        return response

    phone_call_model = {
        "totalCategory" : call_label,
        "totalCategoryScore" : weighted_probs[call_label].item(),
        "results" : session_store[session_id].copy() if is_finish else [sentence_model] # temporary value
    }

    del session_store[session_id]
    del prob_store[session_id]

    return phone_call_model

@router.post("/test")
async def junghee_test(input_model : ReferenceInputModel):
    return { "result" : [0.1, 0.2, 0.3, 0.4]}

    
