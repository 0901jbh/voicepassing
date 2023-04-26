import torch
from dataLoader import small_train_loader
from model import VoicePassingModel
from transformers import DistilBertTokenizer
from tqdm import tqdm

trainer_config = {
    'model' : VoicePassingModel(),
}

class VoicePassingTrainer():

    def __init__(self, model):

        self.device = "cuda" if torch.cuda.is_available() else 'cpu'
        self.model = model.to(self.device)
        self.tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-uncased")

    def set_model(self, model):
        self.model = model.to(self.device)

    def train(self, num_epochs, train_loader, criterion, lr = 0.003, hist = False):

        self.criterion = criterion
        self.optimizer = torch.optim.Adam(params = self.model.parameters(), lr = lr)
        self.model.train()

        for num_epoch in tqdm(range(num_epochs), desc="EPOCH", leave = True):
            result = self.train_one_epoch(num_epoch, train_loader, hist = hist)
            

    def train_one_epoch(self, index, train_loader, verbose = True, hist = False):

        train_loss = 0

        for X, y in tqdm(train_loader, desc="batch", leave=False):

            X = self.tokenizer(
                text = X,
                add_special_tokens = True,
                max_length = 512,
                padding = "max_length",
                truncation = True,
                return_tensors = "pt"
            ).to(self.device)

            y = y.squeeze().to(self.device)

            pred = self.model(X)
            loss = self.criterion(pred, y)
            train_loss += loss.item()

            loss.backward()
            self.optimizer.step()

        if verbose:
            print(f"EPOCH {index+1} Loss : {train_loss : .4f}")
            print(pred)
        
        if hist:
            return train_loss

    def test_a_sentence(self, text):

        X = self.tokenizer(
                text = text,
                add_special_tokens = True,
                max_length = 512,
                padding = "max_length",
                truncation = True,
                return_tensors = "pt"
            ).to(self.device)
        
        pred = self.model(X)
        return pred