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

@router.post("", response_model = PhoneCallModel, status_code = 200)
async def classify_sentence(input_model : ReferenceInputModel, response : Response):

    text = input_model.text
    is_finish = input_model.isFinish
    session_id = input_model.sessionId

    # classification using bayesian classifier
    label, label_probs, word_probs = pipeline.forward(text)

    # 분기 1 : 혐의 없음 (분석을 했는데, 보이스피싱이 아닌 경우)
    if label == 0:
        empty_phone_call_model = PhoneCallModel()
        response.status_code = 204
        return empty_phone_call_model

    # 가장 확률이 높은 단어 추출
    words, probs = zip(*word_probs)
    print('probs bf smx', probs),
    probs = softmax(torch.FloatTensor(probs))
    print('probs bf after', probs),
    best_prob_idx = torch.argmax(probs)
    best_word = words[best_prob_idx]
    best_prob = probs[best_prob_idx].item()
    print('label probs', label_probs)

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

    session_store[session_id].append(sentence_model)

    # 분기 2 : 혐의 있음, 통화 지속됨 (분석을 했는데, 보이스피싱에 해당하는 경우 + 통화가 안 끝났을 경우)
    if not is_finish:
        empty_phone_call_model = PhoneCallModel(results = [sentence_model])
        return empty_phone_call_model

    classify_phonecall(session_store.get(session_id))
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

    