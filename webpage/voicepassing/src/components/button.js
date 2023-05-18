import { styled } from "styled-components"
import voicepassing from "../file/voicepassing.apk"

function DownloadBtn() {
  return (
    <>
      <ButtonWrapper>
        <TextDiv href={voicepassing} download="">
          VoicePassing 다운로드
        </TextDiv>
      </ButtonWrapper>
    </>
  )
}

export default DownloadBtn

const ButtonWrapper = styled.div`
  width: 312px;

  background-color: #4488ee;
  cursor: pointer;

  box-shadow: 0px 4px 4px 0px #00000040;
  border-radius: 6px;

  position: fixed;
  bottom: 24px;
  left: calc(50vw - 156px);

  font-family: "Noto Sans KR";
  font-style: normal;
  font-weight: 700;
  font-size: 20px;
  line-height: 29px;

  text-align: center;

  color: #ffffff;
`

const TextDiv = styled.a`
  display: flex;
  justify-content: center;
  align-itmes: center;

  margin-top: 10px;
  margin-bottom: 10px;
  text-decoration: none;
  color: white;
`
