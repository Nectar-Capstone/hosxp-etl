CREATE TABLE t_patient (
     patient_hn CHAR(64),
     t_patient_id CHAR(13),
     patient_firstname VARCHAR(256),
     patient_lastname VARCHAR(256),
     patient_birthday DATE,
     f_sex_id VARCHAR(6),
     patient_patient_mobile_phone CHAR(10),
     patient_contact_firstname VARCHAR(256),
     patient_contact_lastname VARCHAR(256),
     patient_contact_sex_id VARCHAR(6),
     patient_contact_phone_number CHAR(10),
     create_at TIMESTAMP NOT NULL DEFAULT now(),
     PRIMARY KEY (patient_hn)
);

CREATE TABLE b_item_drug (
     b_item_drug_id CHAR(7),
     item_drug_printable VARCHAR(256),
     create_at TIMESTAMP DEFAULT now(),
     PRIMARY KEY (b_item_drug_id)
);

CREATE TABLE t_visit (
     t_visit_id INT AUTO_INCREMENT,
     visit_hn CHAR(64),
     visit_date TIMESTAMP NOT NULL DEFAULT now(),
     PRIMARY KEY (t_visit_id),
     FOREIGN KEY (visit_hn) REFERENCES t_patient (patient_hn)
);

CREATE TABLE t_order (
     t_order_id INT AUTO_INCREMENT,
     t_visit_id INT,
     b_item_id CHAR(7),
     order_date_time TIMESTAMP NOT NULL DEFAULT now(),
     PRIMARY KEY (t_order_id),
     FOREIGN KEY (t_visit_id) REFERENCES t_visit (t_visit_id)
);

CREATE TABLE t_order_drug (
     t_order_drug_id INT AUTO_INCREMENT,
     t_order_id INT,
     order_drug_printable VARCHAR(256),
     order_drug_special_prescription_text VARCHAR(256),
     order_drug_date_time TIMESTAMP NOT NULL DEFAULT now(),
     PRIMARY KEY (t_order_drug_id),
     FOREIGN KEY (t_order_id) REFERENCES t_order (t_order_id)
);

CREATE TABLE b_allergy_agents (
	 b_allergy_item_id CHAR(4),
	 item_allergy_printable VARCHAR(256),
     create_at TIMESTAMP DEFAULT now(),
     PRIMARY KEY (b_allergy_item_id)
);

CREATE TABLE t_patient_drug_allergy (
     t_patient_drug_allergy_id INT AUTO_INCREMENT,
     t_patient_id CHAR(13),
     b_item_id CHAR(4),
     patient_drug_allergy_symptom VARCHAR(256),
     patient_drug_allergy_record_date_time TIMESTAMP NOT NULL DEFAULT now(),
     PRIMARY KEY (t_patient_drug_allergy_id),
     FOREIGN KEY (b_item_id) REFERENCES b_allergy_agents (b_allergy_item_id)
);

CREATE TABLE b_icd10 (
     icd10_number CHAR(5),
     icd10_description VARCHAR(512),
     PRIMARY KEY (icd10_number)
);

CREATE TABLE t_diag_icd10 (
     t_diag_icd10_id INT AUTO_INCREMENT,
     b_visit_clinic_id INT,
     diag_icd10_number CHAR(5),
     diag_icd10_notice VARCHAR(8),
     diag_icd10_record_date_time TIMESTAMP NOT NULL DEFAULT now(),
     diag_icd10_active BOOLEAN,
     PRIMARY KEY (t_diag_icd10_id),
     FOREIGN KEY (b_visit_clinic_id) REFERENCES t_visit(t_visit_id),
     FOREIGN KEY (diag_icd10_number) REFERENCES b_icd10(icd10_number)
);