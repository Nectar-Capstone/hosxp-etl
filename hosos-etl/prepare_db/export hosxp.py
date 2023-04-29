import mysql.connector
import pandas as pd

mydb = mysql.connector.connect(
    host = 'localhost',
    port = 3307,
    user = 'root',
    password = 'Panus@2544',
    database = 'hosos'
)
sql = """
SELECT b_allergy_item_id, item_allergy_printable FROM b_allergy_agents
"""
columns= ['b_allergy_item_id', 'item_allergy_printable']

mycursor = mydb.cursor()
mycursor.execute(sql)
result = mycursor.fetchall()
df = pd.DataFrame.from_records(result, columns=columns)
df.to_excel('allergy.xlsx')