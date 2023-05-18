import favicon from "../file/favicon.ico"

function Mobile() {
  const path = "../file"
  return (
    <>
      <a href={favicon} download="">
        <img src={favicon} />
      </a>
    </>
  )
}
export default Mobile
