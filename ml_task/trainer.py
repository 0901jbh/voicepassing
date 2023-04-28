import torch
from dataLoader import VoicePassingDataloader
from model import VoicePassingModel
from transformers import DistilBertTokenizer, AdamW
from tqdm import tqdm

trainer_config = {
    'model' : VoicePassingModel(),
}

class VoicePassingTrainer():

    def __init__(self, model):

        self.device = "cuda" if torch.cuda.is_available() else 'cpu'
        self.model = model.to(self.device)
        self.tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-uncased")
        self.train_loss_history = []
        self.train_acc_history = []
        self.valid_loss_history = []
        self.valid_acc_history = []

    def set_model(self, model):
        self.model = model.to(self.device)

    def get_history(self):

        history = {
            "train_loss" : self.train_loss_history,
            "train_accuracy" : self.train_acc_history,
            "valid_loss" : self.valid_loss_history,
            "valid_accuracy" : self.valid_acc_history
        }

        return history

    def train(self, num_epochs, train_loader, criterion, lr = 3e-5, valid_loader = None, reset_history = False, verbose = True):

        if reset_history:
            self.train_loss_history = []
            self.train_acc_history = []
            self.valid_loss_history = []
            self.valid_acc_history = []

        self.criterion = criterion
        self.optimizer = AdamW(params = self.model.parameters(), lr = lr, correct_bias=False)
        self.model.train()

        for epoch_idx in range(num_epochs):
            train_loss, train_acc = self.train_one_epoch(epoch_idx, train_loader, verbose = verbose)

            self.train_loss_history.append(train_loss)
            self.train_acc_history.append(train_acc)

            if valid_loader:
                valid_loss, valid_acc = self.validate(epoch_idx, valid_loader, verbose = verbose)

                # 모델 저장
                if not epoch_idx: # 저장된 게 없다면
                    torch.save(self.model.state_dict(), r"./result/best.pt")
                    print("the initial model saved")

                else:
                    if valid_loss < self.valid_loss_history[-1]:
                        torch.save(self.model.state_dict(), fr"./result/best.pt")
                        print("the best model saved")

                self.valid_loss_history.append(valid_loss)
                self.valid_acc_history.append(valid_acc)

        torch.save(self.model.state_dict(), fr"./result/last.pt")
        print("the last model saved")

    def train_one_epoch(self, index, train_loader, verbose = True):

        train_loss = 0
        train_correct = 0
        train_n_probs = 0

        for X, y in tqdm(train_loader, desc="batch", leave= True):

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

            pred_labels = pred.argmax(axis = 1)
            n_correct = len(torch.where(pred_labels == y)[0])

            train_correct += n_correct
            train_n_probs += len(y)

        train_acc = (train_correct / train_n_probs) * 100

        if verbose:
            print(f"EPOCH {index+1} TRAIN / Loss : {train_loss : .4f}, Acc : {train_acc : .4f}")
            print(pred[-4:])
            print(y[-4:])

        return train_loss, train_acc

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
    
    def validate(self, index, valid_loader, verbose = True):

        valid_correct = 0
        valid_n_probs = 0
        
        self.model.eval()

        for X, y in tqdm(valid_loader, desc="batch", leave= True):

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
            valid_loss = self.criterion(pred, y).item()

            pred_labels = pred.argmax(axis = 1)
            n_correct = len(torch.where(pred_labels == y)[0])

            valid_correct += n_correct
            valid_n_probs += len(y)

        valid_acc = (valid_correct / valid_n_probs) * 100

        if verbose:
            print(f"EPOCH {index+1} VALID / Loss : {valid_loss : .4f}, Acc : {valid_acc : .4f}")
            print(pred[-4:])
            print(y[-4:])
        
        return valid_loss, valid_acc
        