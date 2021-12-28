
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def video_feed():
    print('hello');

