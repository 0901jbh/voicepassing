from pydantic import BaseModel, Field

class StringModel(BaseModel):
    # Naver API로부터 반환받은 Text
    text : str = Field(example = "네 저는 금융범죄 수사 1팀의 김철민 수사관이고요")