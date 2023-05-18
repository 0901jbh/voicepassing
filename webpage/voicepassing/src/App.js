import { BrowserView, MobileView } from "react-device-detect"
import Prevent from "./components/prevent"
import Search from "./components/search"
import Find from "./components/find"
import Head from "./components/head"
import { styled } from "styled-components"
import DownloadBtn from "./components/button"

function App() {
  return (
    <Wrapper>
      <Head />
      <Prevent />
      <Find />
      <Search />
      <DownloadBtn />
      <BlankDiv />
    </Wrapper>
  )
}

export default App

const Wrapper = styled.div`
  position: relative;
  width: 100vw;
  height: 100vh;
`

const BlankDiv = styled.div`
  height: 100px;
  background-color: white;
`
