from fastapi import APIRouter, Response, status
from model import ReferenceInputModel, SentenceModel, PhoneCallModel
from classifier.model import model as classifier
from classifier.model import pipeline
import torch
from torch.cuda import is_available
from transformers import DistilBertTokenizer
from utils import classify_phonecall
import kss

import pandas as pd

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")
device = "cuda" if is_available else "cpu"
softmax = torch.nn.Softmax(dim = 0)

sentence_store = dict() # SentenceModel을 저장
prob_store = dict() # 문장의 분류 결과 (float[4])를 저장.

T = 36
THRESHOLD = 0.5

@router.post("", response_model = PhoneCallModel, status_code = 200)
async def classify_sentence(input_model : ReferenceInputModel, response : Response):

    temp_prob_store = [] # 받아온 문장별 label 확률을 저장
    temp_sentence_store = [] # 받아온 문장별 SentenceModel을 저장

    text = input_model.text
    is_finish = input_model.isFinish
    session_id = input_model.sessionId

    # 문장 자르기
    text_splited = [t for t in kss.split_sentences(text) if len(t) > 10]

    # 1. BERT Classification
    ## 1.1. Tokenization
    tokens = tokenizer(
        text = text_splited,
        add_special_tokens = True,
        truncation = True,
        max_length = 512,
        padding = True,
        return_tensors = "pt"
    )

    output, _ = classifier(tokens)

    print(f"RAW : {output.squeeze()}")
    if output.shape[0] != 1:
        label_probs = torch.nn.functional.softmax(output.squeeze() / T, dim = 1)
    else:
        label_probs = torch.nn.functional.softmax(output / T, dim = 1)

    # 2. Bayesian Classification
    b_label_probs, word_probs = pipeline.forward(text_splited)

    # 3. get result and save

    print(f"BERT : {label_probs}")
    print(f"NB : {torch.FloatTensor(b_label_probs)}")

    label_probs = (label_probs + torch.FloatTensor(b_label_probs)) / 2

    print(f"TOTAL : {label_probs}")
    
    label = torch.argmax(label_probs, dim = 1)
    print(f"LABEL : {label}")
        
    temp_prob_store = label_probs.detach().cpu().numpy().tolist()

    ## 3.1. label 설정하기

    answer_prob = torch.gather(label_probs, dim = 1, index = label.unsqueeze(1))
    unqualified = torch.where(answer_prob < THRESHOLD)[0] # 기준 밑으로 혐의 없음
    label[unqualified] = 0
    
    # 4. 특정 키워드 추출하기

    temp_store = []

    for idx, word_prob in enumerate(word_probs):

        temp_store.append(label_probs[idx])
        cur_label = label[idx].item()

        if cur_label == 0: # 평가 결과 음수일 경우
            continue

        # 평가 결과가 음수가 아닌 경우

        words, probs = zip(*word_prob.as_list(label = cur_label))

        probs = softmax(torch.FloatTensor(probs))
        best_prob_idx = torch.argmax(probs)
        best_word = words[best_prob_idx]
        best_prob = probs[best_prob_idx].item()

        sentence_model = SentenceModel(
            sentCategory = cur_label,
            sentCategoryScore = label_probs[idx][cur_label].item(),
            sentKeyword = best_word,
            keywordScore = best_prob,
            sentence = text_splited[idx]
        )

        temp_sentence_store.append(sentence_model.dict())

    prob_store_value = prob_store.get(session_id)
    sentence_store_value = sentence_store.get(session_id)

    if not prob_store_value:
        prob_store[session_id] = []
    if not sentence_store_value:
        sentence_store[session_id] = []

    prob_store[session_id].extend(temp_prob_store)
    sentence_store[session_id].extend(temp_sentence_store)

    # 결과값 반환

    if not is_finish : # 아직 안 끝났을 경우

        weighted_probs, call_label = classify_phonecall(temp_prob_store)

        if call_label == 0:
            response.status_code = 204
            return response

        phone_call_model = {
            "totalCategory" : call_label,
            "totalCategoryScore" : weighted_probs[call_label].item(),
            "results" : temp_sentence_store
        }


    else: # 끝났을 경우
        
        weighted_probs, call_label = classify_phonecall(prob_store[session_id])

        phone_call_model = {
            "totalCategory" : call_label,
            "totalCategoryScore" : weighted_probs[call_label].item(),
            "results" : sentence_store[session_id]
        }

        del sentence_store[session_id]
        del prob_store[session_id]

    return phone_call_model

@router.post("/test")
async def junghee_test(input_model : ReferenceInputModel):
    return { "result" : [0.1, 0.2, 0.3, 0.4]}

    
