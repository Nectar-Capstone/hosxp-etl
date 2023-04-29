import pandas as pd
import hashlib

df1 = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_patient', dtype=str)
df1['patient_hn'] = df1['t_patient_id'].apply(lambda x: hashlib.sha256(x.encode()).hexdigest())
val = df1[['patient_hn']].to_dict()['patient_hn']
df2 = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_visit', dtype=str)
df2['visit_hn'] = df2['visit_hn'].apply(lambda x: val[int(x) - 1])
print(df2)