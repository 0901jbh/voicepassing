import { styled } from "styled-components"
import search from "../assets/search.png"

function Search() {
  return (
    <>
      <SearchWrapper>
        <SearchTitleDiv>보이스피싱을</SearchTitleDiv>
        <SearchTitleDiv className="special">찾다</SearchTitleDiv>
        <SearchSubDiv>보이스피싱 이력과</SearchSubDiv>
        <SearchSubDiv>통계 데이터를 제공</SearchSubDiv>
        <ImageWrapper>
          <img src={search} width={293} height={315} />
        </ImageWrapper>
      </SearchWrapper>
    </>
  )
}

export default Search

const SearchWrapper = styled.div`
  background-color: #ffeeee;
  display: flex;
  justify-content: center;
  flex-direction: column;
  padding: 20px 0px 0px 0px;
`

const SearchTitleDiv = styled.div`
  color: black;
  font-family: Noto Sans KR;
  font-size: 30px;
  font-weight: 700;
  line-height: 43px;
  letter-spacing: 0em;
  text-align: center;

  &.special {
    color: #ff525e;
    margin-bottom: 12px;
  }
`

const SearchSubDiv = styled.div`
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
  height: 250px;
  overflow: hidden;
`
