import mysql.connector
import schedule
import time
import pandas as pd
from json import dumps
from kafka import KafkaProducer

# Have not cap create_date yet -> add WHERE creat_at > DATE(NOW()) - 1

patientSql = """
SELECT patient_hn, t_patient_id, CONCAT(patient_firstname, ' ', patient_lastname), patient_birthday, f_sex_id, patient_patient_mobile_phone,
CONCAT(patient_contact_firstname, ' ', patient_contact_lastname), "Emergency contact person", patient_contact_sex_id, patient_contact_phone_number
FROM t_patient
"""

patientColumns = ['uid', 'cid', 'name', 'birthDate', 'gender', 'telecom', 'contact_name', 'contact_relationship', 'contact_gender', 'contact_telcom']

isTakingSql = """
SELECT v.visit_hn, b_item_id, o.order_date_time, od.order_drug_printable, od.order_drug_special_prescription_text
FROM t_visit v, t_order o, t_order_drug od
WHERE v.t_visit_id = o.t_visit_id AND o.t_order_id = od.t_order_id
"""

isTakingColumns = ['uid', 'code', 'authoredOn', 'dosageInstruction', 'note']

isAllergicSql = """
SELECT p.patient_hn, b_item_id, 'active', 'confirmed', 'allergy', 'medication', patient_drug_allergy_symptom, patient_drug_allergy_record_date_time
FROM t_patient_drug_allergy a, t_patient p
WHERE a.t_patient_id = p.t_patient_id
"""

isAllergicColumns = ['uid', 'code', 'clinicalStatus', 'verificationStatus', 'type', 'category', 'criticality', 'recordDate']

isHavingSql = """
SELECT v.visit_hn, diag_icd10_number, CASE WHEN diag_icd10_active = 1 THEN 'active' ELSE 'resolved' END as active,
'confirmed', 'problem-list-item', diag_icd10_notice, diag_icd10_record_date_time
FROM t_visit v, t_diag_icd10 d
WHERE v.t_visit_id = d.b_visit_clinic_id
"""

isHavingColumns = ['uid', 'code', 'clinicalStatus', 'verificationStatus', 'category', 'severity', 'recordDate']

def transform(sql, columns):

    mydb = mysql.connector.connect(
        host = 'db',
        user = 'root',
        password = 'password',
        database = 'hosos'
    )

    mycursor = mydb.cursor()
    mycursor.execute(sql)
    result = mycursor.fetchall()
    df = pd.DataFrame.from_records(result, columns=columns)
    for column in df.columns:
        try: df[column] = df[column].apply(lambda x: pd.to_datetime(x).isoformat(timespec='milliseconds'))
        except: continue
    if 'gender' in columns: df.set_index('uid', inplace=True)
    # else: df.set_index('code', inplace=True)
    return df

def ETL():
    patient = transform(patientSql, patientColumns).to_dict('index')
    # contact = transform(contactSql, contactColumns).to_dict('index')
    all_patient = dict()
    for i in patient:
        patient[i]['uid'] = i
        all_patient[i] = dict()
        all_patient[i]['patient'] = patient[i]
        all_patient[i]['isTaking'] = []
        all_patient[i]['isAllergic'] = []
        all_patient[i]['isHaving'] = []

    isTaking = transform(isTakingSql, isTakingColumns).to_dict('index')
    for i in isTaking:
        uid = isTaking[i]['uid']
        all_patient[uid]['isTaking'].append(isTaking[i])

    isAllergic = transform(isAllergicSql, isAllergicColumns).to_dict('index')
    for i in isAllergic:
        uid = isAllergic[i]['uid']
        all_patient[uid]['isAllergic'].append(isAllergic[i])

    isHaving = transform(isHavingSql, isHavingColumns).to_dict('index')
    for i in isHaving:
        uid = isHaving[i]['uid']
        all_patient[uid]['isHaving'].append(isHaving[i])

    list_all_patient = [all_patient[i] for i in all_patient]
    return list_all_patient

def job():
    producer = KafkaProducer(bootstrap_servers=['broker:29092'],
                         value_serializer=lambda x: 
                         dumps(x).encode('utf-8'))
    patients = ETL()
    #producer.send('patient1', value='HELLO WORLD')
    for i in range(500): 
        producer.send('patient1', value=str([patients[i]]))
        producer.flush()
        print("patient", i)
    print('running schedule')

# schedule.every(5).seconds.do(job)
# for i in range(3):
#     schedule.run_pending()
#     time.sleep(5)

print('sleeping soon')
time.sleep(15)
job()