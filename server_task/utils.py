from typing import List
import torch

def classify_phonecall(results : List | None):
    # 가중 평균을 통해 통화 내용을 판단

    if results is not None:

        label_probs = torch.FloatTensor(results)
        weights = torch.arange(start = len(label_probs), end = 0, step = -1)

        weighted_probs = torch.sum((label_probs.T*weights).T, axis = 0)/torch.sum(weights)
        label = torch.argmax(weighted_probs).item()

        # 0.6을 넘지 않으면, 그냥 문제 없다고 판단
        if weighted_probs[label] < 0.6:
            label = 0

    else:
        weighted_probs = torch.FloatTensor([0])
        label = 0

    return weighted_probs, label
