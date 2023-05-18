from fastapi import APIRouter, Response
from model import ReferenceInputModel, SentenceModel, PhoneCallModel
from classifier.model import model as classifier
from classifier.model import pipeline
import torch
from torch.cuda import is_available
from transformers import DistilBertTokenizer
from utils import classify_phonecall, threshold_scaling
import kss
import numpy as np
import pandas as pd

router = APIRouter(
    prefix="/inference"
)

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")
device = "cuda" if is_available else "cpu"
softmax = torch.nn.Softmax(dim = 0)

sentence_store = dict() # SentenceModel을 저장
prob_store = dict() # 문장의 분류 결과 (float[4])를 저장.

T = 14
BERT_WEIGHT = 0.55
NB_WEIGHT = 0.45
THRESHOLD = 0.6

@router.post("", response_model = PhoneCallModel, status_code = 200)
async def classify_sentence(input_model : ReferenceInputModel, response : Response):

    temp_prob_store = [] # 받아온 문장별 label 확률을 저장
    temp_sentence_store = [] # 받아온 문장별 SentenceModel을 저장

    text = input_model.text
    is_finish = input_model.isFinish
    session_id = input_model.sessionId

    # 문장 자르기
    text_splited = [t for t in kss.split_sentences(text) if len(t) > 10]

    if not text_splited: # 문장 없으면
        weighted_probs, call_label = classify_phonecall(prob_store.get(session_id, None))

        phone_call_model = {
            "totalCategory" : call_label,
            "totalCategoryScore" : threshold_scaling(weighted_probs[call_label].item()),
            "results" : sentence_store.get(session_id, [])
        }

        if call_label == 0:
            response.status_code = 201

        if is_finish: # 그래도 마지막이라면
            if sentence_store.get(session_id):
                del sentence_store[session_id]
            if prob_store.get(session_id):
                del prob_store[session_id]

        return phone_call_model
    
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

    output, attention = classifier(tokens)

    # col = tokenizer.tokenize(text_splited[0])
    # print(col)

    # a = pd.DataFrame(data = torch.mean(attention[-1], dim = 1).squeeze().detach().numpy(), columns = ["cls"] + col + ["sep"])
    # a.to_excel("attention.xlsx")

    print(f"RAW : {output.squeeze()}")

    if output.shape[0] != 1:
        label_probs = torch.nn.functional.softmax(output.squeeze() / T, dim = 1)
    else:
        label_probs = torch.nn.functional.softmax(output / T, dim = 1)

    # 2. Bayesian Classification
    
    b_label_probs = pipeline.forward(text_splited)
    b_label_probs = torch.FloatTensor(b_label_probs)

    # 3. get result and save

    # print(f"BERT : {label_probs}")
    # print(f"NB : {torch.FloatTensor(b_label_probs)}")

    label_probs = label_probs*BERT_WEIGHT + b_label_probs*NB_WEIGHT

    # print(f"TOTAL : {label_probs}")
    
    label = torch.argmax(label_probs, dim = 1)
    # print(f"LABEL : {label}")        
    temp_prob_store = label_probs.detach().cpu().numpy().tolist()

    ## 3.1. label 설정하기

    answer_prob = torch.gather(label_probs, dim = 1, index = label.unsqueeze(1))
    unqualified = torch.where(answer_prob < THRESHOLD)[0] # 기준 밑으로 혐의 없음
    label[unqualified] = 0
    
    # 4. 특정 키워드 추출하기

    temp_store = []

    for idx, one_sentence in enumerate(text_splited):

        temp_store.append(label_probs[idx])
        cur_label = label[idx].item()

        if cur_label == 0:
            continue

        word, prob = pipeline.extract_word_and_probs(one_sentence, cur_label)

        if word is not None:
            sentence_model = SentenceModel(
                sentCategory = cur_label,
                sentCategoryScore = label_probs[idx][cur_label].item(),
                sentKeyword = word,
                keywordScore = abs(prob),
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

        phone_call_model = {
            "totalCategory" : call_label,
            "totalCategoryScore" : weighted_probs[call_label].item(),
            "results" : temp_sentence_store
        }

        if call_label == 0 or not temp_sentence_store:
            response.status_code = 201

    else: # 끝났을 경우
        
        weighted_probs, call_label = classify_phonecall(prob_store[session_id])

        phone_call_model = {
            "totalCategory" : call_label,
            "totalCategoryScore" : threshold_scaling(weighted_probs[call_label].item()),
            "results" : sentence_store[session_id]
        }

        if call_label == 0 or not temp_sentence_store:
            response.status_code = 201

        del sentence_store[session_id]
        del prob_store[session_id]

    return phone_call_model

@router.post("/test")
async def test():

    file_path = r"../data_task/dataset/test_data.xlsx"
    test_data = pd.read_excel(file_path, index_col = 0)

    texts = test_data.text.values.tolist()
    labels = test_data.label.values

    # print(text_splited)

    # BERT 
    tokens = tokenizer(
        text = texts,
        add_special_tokens = True,
        truncation = True,
        max_length = 512,
        padding = True,
        return_tensors = "pt"
    )

    print("==== Tokenizing 완료 ====")

    output, _ = classifier(tokens)

    print("==== Inference 완료 ====")

    output = output.detach().numpy()
    pd.DataFrame(data = output).to_csv("bert2_output.csv")

    # b_label_probs = pipeline.forward(texts)
    # print(type(b_label_probs))

    # pd.DataFrame(data = np.array(b_label_probs)).to_csv("nb_outupt.csv")
    # pd.DataFrame(data = labels.reshape(-1, 1)).to_csv("label.csv")

    return { "result" : [0.1, 0.2, 0.3, 0.4]}

    
