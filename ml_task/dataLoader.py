from torch.utils.data import DataLoader
from dataset import VoicePassingDataset

dataset = VoicePassingDataset()
small_dataset = VoicePassingDataset(small = True)

train_loader = DataLoader(dataset = dataset, batch_size = 4)
small_train_loader = DataLoader(dataset = small_dataset, batch_size = 4)




