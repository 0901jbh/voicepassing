import torch
from dataLoader import VoicePassingDataloader
from model import VoicePassingModel
from trainer import VoicePassingTrainer
import random
import numpy as np
import os
import pickle
import pandas as pd

# seed setting
RANDOM_SEED = 42

random.seed(RANDOM_SEED)
np.random.seed(RANDOM_SEED)
torch.manual_seed(RANDOM_SEED)
torch.cuda.manual_seed(RANDOM_SEED)

# GPU setting
os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"] = "4"

device = "cuda" if torch.cuda.is_available() else "cpu"

print(f"== the current device is {device} ==")

# trainer setting
trainer = VoicePassingTrainer(model = VoicePassingModel())
criterion = torch.nn.CrossEntropyLoss()

# train
trainer.train(200, train_loader = VoicePassingDataloader(
                                    batch_size=64,
                                    shuffle=True,
                                    non_augmented=True,
                                    ),
            criterion = criterion,
            valid_loader = VoicePassingDataloader(
                                    batch_size=64,
                                    shuffle=False,
                                    non_augmented=True,
                                    test = True,
                                    )
            )

# save result
history = trainer.get_history()

pd.DataFrame(data=np.array(history["train_accuracy"]).T).to_csv("ta.csv")
pd.DataFrame(data=np.array(history["train_loss"]).T).to_csv("tl.csv")
pd.DataFrame(data=np.array(history["valid_accuracy"]).T).to_csv("va.csv")
pd.DataFrame(data=np.array(history["valid_loss"]).T).to_csv("vl.csv")


print("== The Process is DONE! ==")