from torch.utils.data import Dataset
import pandas as pd
import torch

class VoicePassingDataset(Dataset):

    def __init__(self, small = False, test = False, non_augmented = False):
        super(VoicePassingDataset, self).__init__()

        if not test:
            dataFrame = pd.read_excel("../data_task/dataset/train_data.xlsx", index_col=0)
        else:
            dataFrame = pd.read_excel("../data_task/dataset/test_data.xlsx", index_col = 0)

        if non_augmented:
            label_0 = dataFrame[dataFrame['label'] == 0]
            dataFrame = dataFrame[dataFrame['augmented'] == 0]
            dataFrame = dataFrame[dataFrame['label'] != 0]

            if test:
                dataFrame = pd.concat([dataFrame, label_0[:100]])
            else:
                dataFrame = pd.concat([dataFrame, label_0[:1000]])
            dataFrame.sample(frac = 1).reset_index()

        if small: # small dataset for test only
            dataFrame = dataFrame.sample(n = 100, ignore_index = True, random_state = 42, replace = False)
            
        self.dataFrame = dataFrame

    def __getitem__(self, idx):
        text, label, _ = self.dataFrame.iloc[idx].values
        label = torch.LongTensor([label])

        return text, label
    
    def __len__(self):
        return len(self.dataFrame)
