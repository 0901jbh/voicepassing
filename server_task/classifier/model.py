from transformers import DistilBertModel
import torch
import torch.nn as nn
import os
import pickle
import numpy as np
from sklearn.pipeline import make_pipeline
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from lime.lime_text import LimeTextExplainer

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

        with open("./classifier/tf_vectorizer.pickle", "rb") as f:
            self.vectorizer = pickle.load(f)

        with open("./classifier/bayesian_classifier.pickle", "rb") as f:
            self.bayesian_classifier = pickle.load(f)

        self.pipe_line = make_pipeline(self.vectorizer, self.bayesian_classifier)
        self.explainer = LimeTextExplainer(class_names=["혐의 없음", "기관 사칭형", "대출 빙자형", "기타"])

    def forward(self, string):

        result = self.pipe_line.predict_proba([string])
        exp = self.explainer.explain_instance(string, self.pipe_line.predict_proba, num_features = 10, top_labels = 4)
        label = np.argmax(result)

        return label, result.squeeze().tolist(), exp

model = VoicePassingModel()
pipeline = bayesianClassifierPipeLine()

