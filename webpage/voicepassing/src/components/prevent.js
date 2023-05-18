import { styled } from "styled-components"
import prevent from "../assets/prevent.png"

function Prevent() {
  return (
    <>
      <PreventWrapper>
        <PreventTitleDiv>보이스피싱을</PreventTitleDiv>
        <PreventTitleDiv className="special">막다</PreventTitleDiv>
        <PreventSubDiv> 실시간 통화를 분석하여</PreventSubDiv>
        <PreventSubDiv> 보이스피싱을 확인</PreventSubDiv>
        <ImageWrapper>
          <img src={prevent} width={300} height={182} />
        </ImageWrapper>
      </PreventWrapper>
    </>
  )
}

export default Prevent

const PreventWrapper = styled.div`
  background-color: #e9f3fd;
  display: flex;
  justify-content: center;
  flex-direction: column;
  padding: 20px 0px 0px 0px;
`

const PreventTitleDiv = styled.div`
  color: black;
  font-family: Noto Sans KR;
  font-size: 30px;
  font-weight: 700;
  line-height: 43px;
  letter-spacing: 0em;
  text-align: center;

  &.special {
    color: #4488ee;
    margin-bottom: 12px;
  }
`

const PreventSubDiv = styled.div`
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
  height: 150px;
  overflow: hidden;
`
