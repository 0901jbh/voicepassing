from transformers import DistilBertModel, DistilBertConfig
import torch.nn as nn

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

        output_1 = self.bertModel(**X)
        hidden_state = output_1[0]
        pooler = hidden_state[:, 0]
        pooler = self.pre_classifier(pooler)
        pooler = self.relu(pooler)
        pooler = self.dropout(pooler)
        output = self.classifier(pooler)

        return output