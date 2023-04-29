import {
  DoctorOrderPrint,
  OpdAllergy,
  OvstDiag,
  Patient,
  PrismaClient,
} from "@prisma/client";
import cron from "node-cron";
import { Kafka, Partitioners } from "kafkajs";
import * as dotenv from "dotenv";
import { isAllergic, isHaving, isTaking, patient, patientISP } from "./types";
import sjcl from "sjcl";

dotenv.config();

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:29092"],
});

const producer = kafka.producer({
  createPartitioner: Partitioners.LegacyPartitioner,
});

const prisma = new PrismaClient();

var task = cron.schedule("* * * * *", async () => {
  try {
    await producer.connect();
    console.log("running cron");
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    const allPatient = await prisma.patient.findMany({
      include: {
        doctor_order_print: {
          where: {
            createdAt: {
              gte: yesterday.toISOString(),
            },
          },
        },
        opd_allergy: {
          where: {
            createdAt: {
              gte: yesterday.toISOString(),
            },
          },
        },
        ovstdiag: {
          where: {
            createdAt: {
              gte: yesterday.toISOString(),
            },
          },
        },
      },
    });
    const patientISP = transformToISP(allPatient);
    console.log(JSON.stringify(patientISP, null, 4));
    await producer.send({
      topic: "patient1",
      messages: [
        {
          value: JSON.stringify(patientISP),
        },
      ],
    });
    await producer.disconnect();
    await prisma.$disconnect();
  } catch (error) {
    console.log(error);
    await prisma.$disconnect();
  }
});

type prismaPatients = (Patient & {
  doctor_order_print: DoctorOrderPrint[];
  opd_allergy: OpdAllergy[];
  ovstdiag: OvstDiag[];
})[];

const sha256 = (message: string): string => {
  const myBitArray = sjcl.hash.sha256.hash(message);
  const myHash = sjcl.codec.hex.fromBits(myBitArray);
  return myHash;
};

const transformToISP = (patients: prismaPatients): patientISP[] => {
  const patientISP: patientISP[] = patients.map((patient) => {
    const isTaking: isTaking[] = patient.doctor_order_print.map((order) => {
      return {
        uid: sha256(patient.cid),
        code: order.icode,
        authoredOn: order.createdAt,
        dosageInstruction: order.shortlist,
        note: "",
      };
    });

    const isAllergic: isAllergic[] = patient.opd_allergy.map((allergy) => {
      return {
        uid: sha256(patient.cid),
        clinicalStatus: "active",
        verificationStatus: "confirmed",
        type: "allergy",
        category: "environment",
        code: allergy.agent,
        criticality: allergy.seriousness,
        recordDate: allergy.createdAt,
      };
    });

    const isHaving: isHaving[] = patient.ovstdiag.map((diag) => {
      return {
        uid: sha256(patient.cid),
        code: diag.icd10_code,
        recordDate: diag.vstdate,
        clinicalStatus: "active",
        verificationStatus: "confirmed",
        category: "problem-list-item",
        severity: "mid",
      };
    });

    const patientTemp: patient = {
      uid: sha256(patient.cid),
      cid: patient.cid,
      name: `${patient.fname} ${patient.lname}`,
      birthdate: patient.birthday,
      gender: patient.contact_gender,
      telecom: patient.contact_telecom,
      contact_name: patient.contact_name,
      contact_relationship: patient.contact_relationship,
      contact_gender: patient.contact_gender,
      contact_telecom: patient.contact_telecom,
    };

    return {
      patient: patientTemp,
      isAllergic: isAllergic,
      isHaving: isHaving,
      isTaking: isTaking,
    };
  });

  return patientISP;
};
