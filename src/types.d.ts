export interface message {
  hospital: string;
  createdAt: Date;
  patient: patientISP;
}

export interface patientISP {
  patient: patient;
  isTaking: isTaking[];
  isAllergic: isAllergic[];
  isHaving: isHaving[];
}

export interface patient {
  uid: string;
  cid: string;
  name: string;
  birthdate: Date;
  gender: string;
  telecom: string;
  contact_name: string;
  contact_relationship: string;
  contact_gender: string;
  contact_telecom: string;
}

export interface isTaking {
  uid: string;
  code: string;
  authoredOn: Date;
  dosageInstruction: string;
  note?: string;
}

export interface isAllergic {
  uid: string;
  code: string;
  clinicalStatus?: string;
  verificationStatus?: string;
  type?: string;
  category?: string;
  criticality: string;
  recordDate: Date;
}

export interface isHaving {
  uid: string;
  code: string;
  clinicalStatus?: string;
  verificationStatus?: string;
  category?: string;
  severity?: string;
  recordDate: Date;
}
