from pydantic import BaseModel, Field
from typing import List

class ReferenceInputModel(BaseModel):
    text : str = Field(example = "네 저는 금융범죄 수사 1팀의 김철민 수사관이고요")
    isFinish : bool = Field(example = False)
    sessionId : str = Field(example = "SSAFY1357")

class SentenceModel(BaseModel):
    sentCategory : int = -1             # 문장 분류 결과
    sentCategoryScore : float = -1.0    # 문장 분류 점수
    sentKeyword : str = ""              # 문장 내 주요 키워드
    keywordScore : float = -1.0         # 문장 내 주요 키워드의 점수
    sentence : str = ""                 # 키워드가 속한 주요 문장

class PhoneCallModel(BaseModel):
    totalCategory : int = -1        # 통화 내용 분류 결과
    totalCategoryScore : float = -1.0  # 통화 내용 분류 점수
    results : List[SentenceModel] | None = []