export interface message {
  hospital: string;
  createdAt: Date;
  patient: patientISP;
}

export interface patientISP {
  uid: string;
  cid: string;
  name: string;
  brithdate: Date;
  gender: string;
  telecom: string;
  contact: Contact;
  isTaking: isTaking[];
  isAllergic: isAllergic[];
  isHaving: isHaving[];
}

export interface Contact {
  name: string;
  uid: string;
  relationship: string;
  gender: string;
  telecom: string;
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
  cetegory?: string;
  severity?: string;
  recordDate: Date;
}
