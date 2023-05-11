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

        self.tokenizer = VoicePassingTokenizer()

        with open("./classifier/vectorizer.pickle", "rb") as f:
            self.vectorizer = pickle.load(f)

        with open("./classifier/nb.pickle", "rb") as f:
            self.bayesian_classifier = pickle.load(f)

        self.pipe_line = make_pipeline(self.vectorizer, self.bayesian_classifier)

    def forward(self, string):

        prob_result = self.pipe_line.predict_proba(string)

        return prob_result
    
    def extract_word_and_probs(self, string, label):

        text_tokens = self.tokenizer.tokenize(string)

        all_cases = [text_tokens.copy() for _ in range(len(text_tokens))]
        all_texts = []

        for idx, row in enumerate(all_cases):
            row[idx] = ""
            all_texts.append("".join(row))

        del all_cases

        prob_result = self.pipe_line.predict_proba(all_texts + [string])
        dif = prob_result - prob_result[-1]

        arg_idx = dif[:-1, label].argmin()

        return text_tokens[arg_idx], dif[arg_idx, label]
        

model = VoicePassingModel()
pipeline = bayesianClassifierPipeLine()

