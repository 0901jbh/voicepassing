import { styled } from "styled-components"
import find from "../assets/find.png"
function Find() {
  return (
    <>
      <FindWrapper>
        <FindTitleDiv>보이스피싱을</FindTitleDiv>
        <FindTitleDiv className="special">확인하다</FindTitleDiv>
        <FindSubDiv>분석 데이터 제공으로</FindSubDiv>
        <FindSubDiv>판단 원인을 확인</FindSubDiv>
        <ImageWrapper>
          <img src={find} width={303} height={281} />
        </ImageWrapper>
      </FindWrapper>
    </>
  )
}

export default Find

const FindWrapper = styled.div`
  background-color: #fff8e5;
  display: flex;
  justify-content: center;
  flex-direction: column;
  padding: 20px 0px 0px 0px;
`

const FindTitleDiv = styled.div`
  color: black;
  font-family: Noto Sans KR;
  font-size: 30px;
  font-weight: 700;
  line-height: 43px;
  letter-spacing: 0em;
  text-align: center;

  &.special {
    color: #ffc041;
    margin-bottom: 12px;
  }
`

const FindSubDiv = styled.div`
  font-family: Noto Sans KR;
  font-size: 15px;
  font-weight: 400;
  line-height: 22px;
  letter-spacing: 0em;
  text-align: center;
`

const ImageWrapper = styled.div`
  display: flex;
  justify-content: center;
  algin-items: center;
  margin-top: 20px;
  height: 230px;
  overflow: hidden;
`
