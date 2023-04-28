import torch
from dataLoader import VoicePassingDataloader
from model import VoicePassingModel
from trainer import VoicePassingTrainer
import random
import numpy as np
import os
import pickle

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
trainer.train(50, train_loader = VoicePassingDataloader(
                                    batch_size=32,
                                    shuffle=True,
                                    non_augmented=True,
                                    small = True
                                    ),
            criterion = criterion,
            valid_loader = VoicePassingDataloader(
                                    batch_size=32,
                                    shuffle=False,
                                    non_augmented=True,
                                    test = True,
                                    small = True
                                    )
            )

# save result
history = trainer.get_history()

with open("history", "wb") as f:
    pk = pickle.dumps(history)
    f.write(pk)

print("== The Process is DONE! ==")