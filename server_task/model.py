from pydantic import BaseModel, Field
from typing import List

class ReferenceInputModel(BaseModel):
    text : str = Field(example = "사실 확인차 연락을 드렸습니다. 본인 혹시 김동철이라는 사람 알고 계세요. 아니요. 모르는데요. 이 사람 출신이고 올해 사십세 된 남성입니다. 네 전혀 모르는 사람이세요. 왜냐하면 저희 검찰에서 얼마 전에 네 김동철 주범으로 인한 금융 범죄 사기단을 검거했으니")
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