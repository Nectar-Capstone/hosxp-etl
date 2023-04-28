import mysql.connector
import pandas as pd
import hashlib


def import_to_db(sql, val):
    mydb = mysql.connector.connect(
    host = 'localhost',
    port = 3307,
    user = 'root',
    password = 'Panus@2544',
    database = 'hosos'
)
    mycursor = mydb.cursor()
    mycursor.executemany(sql, val.tolist())
    mydb.commit()

def t_patient():
    sql = """
    INSERT INTO t_patient (patient_hn, t_patient_id, patient_firstname, patient_lastname,
        patient_birthday, f_sex_id, patient_patient_mobile_phone,
        patient_contact_firstname, patient_contact_lastname,
        patient_contact_sex_id, patient_contact_phone_number) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_patient', dtype=str)
    df['patient_birthday'] = df['patient_birthday'].apply(lambda x: x[:10])
    df['patient_hn'] = df['t_patient_id'].apply(lambda x: hashlib.sha256(x.encode()).hexdigest())
    val = df.to_records(index=False)
    return sql, val, df[['patient_hn']].to_dict()['patient_hn']

def b_item_drug():
    sql = """
    INSERT INTO b_item_drug (b_item_drug_id, item_drug_printable)
    VALUES (%s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='b_item_drug', dtype=str)
    val = df.to_records(index=False)
    return sql, val

def t_visit(hn):
    sql = """
    INSERT INTO t_visit (visit_hn, visit_date)
    VALUES (%s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_visit', dtype=str)
    df['visit_hn'] = df['visit_hn'].apply(lambda x: hn[int(x) - 1])
    val = df[df.columns[df.columns != 't_visit_id']].to_records(index=False)
    return sql, val

def t_order():
    sql = """
    INSERT INTO t_order (t_visit_id, b_item_id, order_date_time)
    VALUES (%s, %s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_order', dtype=str)
    val = df[df.columns[df.columns != 't_order_id']].to_records(index=False)
    return sql, val

def t_order_drug():
    sql = """
    INSERT INTO t_order_drug (t_order_id, order_drug_printable, order_drug_special_prescription_text, order_drug_date_time)
    VALUES (%s, %s, %s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_order_drug', dtype=str)
    val = df[df.columns[df.columns != 't_order_drug_id']].to_records(index=False)
    return sql, val   

def b_allergy_agents():
    sql = """
    INSERT INTO b_allergy_agents (b_allergy_item_id, item_allergy_printable)
    VALUES (%s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='b_allergy_agents', dtype=str)
    val = df.to_records(index=False)
    return sql, val

def t_patient_drug_allergy():
    sql = """
    INSERT INTO t_patient_drug_allergy (t_patient_id, b_item_id, patient_drug_allergy_symptom, patient_drug_allergy_record_date_time)
    VALUES (%s, %s, %s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_patient_drug_allergy', dtype=str)
    val = df.to_records(index=False)
    return sql, val

def b_icd10():
    sql = """
    INSERT INTO b_icd10 (icd10_number, icd10_description)
    VALUES (%s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='b_icd10', dtype=str)
    val = df.to_records(index=False)
    return sql, val

def t_diag_icd10():
    sql = """
    INSERT INTO t_diag_icd10 (b_visit_clinic_id, diag_icd10_number, 
    diag_icd10_notice, diag_icd10_record_date_time, diag_icd10_active)
    VALUES (%s, %s, %s, %s, %s)
    """
    df = pd.read_excel('.\prepare_db\HosOS_mock_data.xlsx', sheet_name='t_diag_icd10', dtype=str)
    val = df[df.columns[df.columns != 't_diag_icd10_id']].to_records(index=False)
    return sql, val

sql, val, hn = t_patient()
import_to_db(sql, val)

sql, val = b_item_drug()
import_to_db(sql, val)

sql, val = t_visit(hn)
import_to_db(sql, val)

sql, val = t_order()
import_to_db(sql, val)

sql, val = t_order_drug()
import_to_db(sql, val)

sql, val = b_allergy_agents()
import_to_db(sql, val)

sql, val = t_patient_drug_allergy()
import_to_db(sql, val)

sql, val = b_icd10()
import_to_db(sql, val)

sql, val = t_diag_icd10()
import_to_db(sql, val)