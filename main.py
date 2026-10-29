#執行fastAPI測試程式前先執行以下指令
#pip install "uvicorn[standard]"
#pip install fastapi
#uvicorn main:app --reload
from fastapi import FastAPI
app = FastAPI()
@app.get("/")
def index():
    return "hello" 
