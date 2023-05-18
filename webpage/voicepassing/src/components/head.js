import styled from "styled-components"
import Main_Header from "../assets/Main_Header(1).png"

function Head() {
  return (
    <>
      <TitleWrapper>
        <TitleDiv>
          <img src={Main_Header} />
        </TitleDiv>
      </TitleWrapper>
    </>
  )
}

export default Head

const TitleWrapper = styled.div`
  width: 100vw;
  // flexbox
  display: flex;
  justify-content: center;
  align-items: center;
`

const TitleDiv = styled.div`
  width: 312px;
  height: 24px;

  padding: 18px 0px 12px 0px;

  display: flex;
  justify-content: start;
`
