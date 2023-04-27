import uvicorn
import argparse
from fastapi import FastAPI

app = FastAPI()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description = "FastAPI Server for communication with AI Model"
    )
    parser.add_argument(
        "--host",
        type=str,
        default="127.0.0.1",
        help="FastAPI 서버 호스트 번호"
    )
    parser.add_argument(
        "--port",
        type=int,
        default=8000,
        help="FastAPI 서버 포트 번호"
    )
    parser.add_argument(
        "--reload",
        action="store_true",
        help="수정사항이 생길 때마다 재시작"
    )

    opt = parser.parse_args()
    print(opt)

    uvicorn.run(app, host=opt.host, port = opt.port, reload = opt.reload)

