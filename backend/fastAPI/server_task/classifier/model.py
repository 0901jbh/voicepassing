from transformers import DistilBertModel, DistilBertTokenizer
import torch
import torch.nn as nn
import os
import pickle
import numpy as np
from sklearn.pipeline import make_pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from lime.lime_text import LimeTextExplainer
import pandas as pd
import json
from kss import split_morphemes

class VoicePassingTokenizer():
    def __init__(self):
        self.tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-multilingual-cased")

        with open('./classifier/new_tokens.pickle', "rb") as f :
            new_tokens = pickle.load(f)

        new_tokens -= set((" "))
        self.tokenizer.add_tokens(list(new_tokens))

    def tokenize(self, text):
        tokens = self.tokenizer.tokenize(text)
        tokens = [token.replace("#", "") for token in tokens]

        return tokens
    
class VoicePassingModel(nn.Module):

    def __init__(self, bert_out = 768, dropout = 0.3, num_classes = 4):

        super(VoicePassingModel, self).__init__()
        self.bertModel = DistilBertModel.from_pretrained("distilbert-base-multilingual-cased")
        
        # freeze non-classifier layers
        for param in self.bertModel.parameters():
            param.requires_grad = False
            
        self.pre_classifier = nn.Linear(bert_out, bert_out)
        self.dropout = nn.Dropout(dropout)
        self.classifier = nn.Linear(bert_out, num_classes)
        self.relu = nn.ReLU()

    def forward(self, X):

        output_1 = self.bertModel(**X, output_attentions = True)

        # # Classification
        hidden_state = output_1['last_hidden_state']
        attentions = output_1['attentions']

        pooler = hidden_state[:, 0]
        pooler = self.pre_classifier(pooler)
        pooler = self.relu(pooler)
        pooler = self.dropout(pooler)
        output = self.classifier(pooler)

        # # Attention

        return output, attentions

class bayesianClassifierPipeLine():

    def __init__(self):

        # self.tokenizer = VoicePassingTokenizer()

        print("======vectorizer 시작============")

        self.vectorizer = TfidfVectorizer(tokenizer = self.tokenize)
        self.cnt = 0

        # dataframe = pd.read_excel(r"C:\Users\SSAFY\Desktop\S08P31A607\data_task\dataset\data_for_tokenizer.xlsx", index_col = 0)

        # data = dataframe.text.values
        # label = dataframe.label.values

        # total_vector = self.vectorizer.fit_transform(data)
        # print(f"total_vector : {total_vector}")

        # with open("./classifier/vectorizer4.pickle", "wb") as f:
        #     pickle.dump(self.vectorizer, f)

        # print("======vectorizer 완============")

        # with open("./classifier/total_vector2.pickle", "wb") as f:
        #     pickle.dump(total_vector, f)

        # print("======vector 완============")

        # nb = MultinomialNB(alpha = 0.1)
        # nb.fit(total_vector, label)

        # with open("./classifier/nb4.pickle", "wb") as f:
        #     pickle.dump(nb, f)

        with open("./classifier/assets/vectorizer4.pickle", "rb") as f:
            self.vectorizer = pickle.load(f)
        
        with open("./classifier/assets/word_weights.json", "r", encoding = "utf-8-sig") as f:
            self.word_weights = json.load(f)

        with open("./classifier/assets/nb4.pickle", "rb") as f:
            self.bayesian_classifier = pickle.load(f)

        self.pipe_line = make_pipeline(self.vectorizer, self.bayesian_classifier)

    def tokenize(self, text):

        final_tokens = []
        text_tokens_n_morphemes = split_morphemes(text)

        # 명사만 추출하기 + 합성어 처리하기
        pre_morph = None

        for token, morph in text_tokens_n_morphemes:

            # final_tokens가 비어 있을 때
            if not final_tokens:
                final_tokens.append(token)
                pre_morph = morph
                continue

            # final_tokens가 비어있지 않을 때
            if morph in {"NNG", "NNP"}: # 이번 토큰이 명사일 때

                if pre_morph in {"NNG", "NNP"}: # 이전 토큰도 명사일 때
                    last_token = final_tokens.pop()
                    final_tokens.append(last_token + token)

                else: # 이전 토큰이 명사가 아닐 때
                    final_tokens.append(token)
                pre_morph = morph
                continue

            if token.isalpha() or token.isnumeric():
                pre_morph = morph
                final_tokens.append(token)
                continue

            pre_morph = morph

        # self.cnt += 1
        # print(self.cnt)

        return final_tokens
    
    def forward(self, string):

        prob_result = self.pipe_line.predict_proba(string)

        return prob_result
    
    def extract_word_and_probs(self, string, label):

        # text_tokens = self.tokenizer.tokenize(string)
        text_tokens_n_morphemes = split_morphemes(string, drop_space=False)

        final_tokens = []
        noun_locs = []

        # 명사만 추출하기 + 합성어 처리하기
        pre_morph = None

        for token, morph in text_tokens_n_morphemes:

            # final_tokens가 비어 있을 때
            if not final_tokens:
                final_tokens.append(token)
                pre_morph = morph

                if morph in {"NNG", "NNP"}:
                    noun_locs.append(len(final_tokens)-1)
                continue

            # final_tokens가 비어있지 않을 때
            if morph in {"NNG", "NNP"}: # 이번 토큰이 명사일 때

                if pre_morph in {"NNG", "NNP"}: # 이전 토큰도 명사일 때
                    last_token = final_tokens.pop()
                    final_tokens.append(last_token + token)

                    noun_locs.pop()
                    noun_locs.append(len(final_tokens)-1)

                else: # 이전 토큰이 명사가 아닐 때
                    final_tokens.append(token)
                    noun_locs.append(len(final_tokens)-1)

                pre_morph = morph
                continue

            if token.isalpha() or token.isnumeric():
                pre_morph = morph
                final_tokens.append(token)
                continue

            pre_morph = morph

        # print(f"final_tokens : {final_tokens}")
        # for n_loc in noun_locs:
            # print(f"nouns : {final_tokens[n_loc]}")

        all_cases = [final_tokens.copy() for _ in range(len(noun_locs))]
        all_texts = []

        nouns = []

        for idx, row in enumerate(all_cases):
            row[noun_locs[idx]] = ""
            nouns.append(final_tokens[noun_locs[idx]])
            all_texts.append("".join(row))
            # print(final_tokens[noun_locs[idx]])
            # print(row)

        del all_cases

        prob_result = self.pipe_line.predict_proba(all_texts + [string])
        # print(f"prob result : {prob_result}")
        dif = (prob_result - prob_result[-1])[:-1, label]
        weights = np.array([self.word_weights.get(noun, 1) for noun in nouns])

        # print(f"dif : {dif}")
        # print(f"nouns : {nouns}")
        # print(f"weights : {weights}")

        dif_weighted = dif * weights

        # print(f"dif_weighted : {dif_weighted}")

        if len(dif_weighted):
            arg_idx = dif_weighted.argmin()
            return final_tokens[noun_locs[arg_idx]], dif_weighted[arg_idx]
        
        else:
            return None, None
        

model = VoicePassingModel()
pipeline = bayesianClassifierPipeLine()

