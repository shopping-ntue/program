#執行fastAPI測試程式前先執行以下指令
#pip install "uvicorn[standard]"
#pip install fastapi
#uvicorn main:app --reload
from fastapi import FastAPI
import pymysql
app = FastAPI()
def get_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='1234567',
        database='world',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
@app.get("/")
def index():
    return "hello" 
@app.get("/cities")
def get_cities():
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM city LIMIT 10")
            results = cursor.fetchall()
            return results
    finally:
        conn.close()
