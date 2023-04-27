from torch.utils.data import DataLoader
from dataset import VoicePassingDataset

class VoicePassingDataloader(DataLoader):

    def __init__(self, small = False, test = False, batch_size = 32, shuffle = False):
        self.dataset = VoicePassingDataset(small = small, test = test)
        super(VoicePassingDataloader, self).__init__(self.dataset, batch_size = batch_size, shuffle = shuffle)





