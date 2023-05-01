import uvicorn
import argparse
from fastapi import FastAPI
from contextlib import asynccontextmanager
from classifier.model import model
from routers import inference
import torch

@asynccontextmanager
async def lifespan(app : FastAPI):
    print("server opened")

    # for name, parameter in model.named_parameters():
    #     if not name.startswith("bert"):
    #         print(parameter, "처음 ")
    #         break

    model.load_state_dict(torch.load(r"./classifier/weight/base_model/last.pt", map_location = torch.device("cpu")))
    model.eval()

    # for name, parameter in model.named_parameters():
    #     if not name.startswith("bert"):
    #         print(parameter, "다운 ")
    #         break

    yield
    print("server closed")
    
app = FastAPI(lifespan = lifespan)
app.include_router(inference.router)

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

    uvicorn.run("__main__:app", host=opt.host, port = opt.port, reload = opt.reload)

