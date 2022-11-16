from fastapi import FastAPI
from typing import Optional
from enum import Enum
from pydantic import BaseModel

patito = FastAPI()

DESCRIPTIONS = {"alexnet": "You selected alexnet model.",
                "resnet": "You selected resnet model.",
                "lenet": "You selected lenet model."}

class ModelName(str, Enum):
    alexnet= "alexnet"
    resnet= "resnet"
    lenet = "lenet"

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

@patito.get("/")
async def root():
    return{"message": "Hello world, From UFM 2022!"}

@patito.get("/users/me")
async def read_user_me():
    return{"user_id":"the current user"}

@patito.get("/users/{user_id}")
async def read_user(user_id: str):
    return{"user_id":user_id}

@patito.get("/models/{model_name}")
async def get_model_data(model_name: ModelName):
    if model_name==ModelName.alexnet:
        return{"model": model_name, "description": "You selected alexnet model."}
    if model_name==ModelName.resnet:
        return{"model": model_name, "description": "You selected resnet model."}
    return{"model": model_name, "description": "You selected lenet model."}

@patito.get("/models_2/{model_name}")
async def get_model_data(model_name: ModelName):
    return{"model": model_name, "description": DESCRIPTIONS[model_name]}

@patito.get("/items/")
async def read_item(skip: int = 0, limit: int = 10):
    return fake_items_db[skip : skip + limit]

@patito.get("/items/{item_id}")
async def read_item(item_id: str, q: Optional[str] = None):
    if q:
        return {"item_id": item_id, "q": q}
    return {"item_id": item_id}

@patito.get("/users/{user_id}/items/{item_id}")
async def read_user_item(
    user_id: int, item_id: str, q: Optional[str] = None, short: bool = False
):
    item = {"item_id": item_id, "owner_id": user_id}
    if q:
        item.update({"q": q})
    if not short:
        item.update(
            {"description": "This is an amazing item that has a long description"}
        )
    return item

@patito.post("/items/")
async def create_item(item: Item):
    return item


@patito.get("/items/{item_id}")
async def read_item(item_id: int):
    return{"item_id":item_id}

# python -m uvicorn file:variable --reload
