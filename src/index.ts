import { PrismaClient } from "@prisma/client";
import cron from "node-cron";
import { Kafka, Partitioners } from "kafkajs";
import * as dotenv from "dotenv";
import { Contact, isAllergic, isHaving, isTaking, patientISP } from "./types";
dotenv.config();

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:29092"],
});

const producer = kafka.producer({
  createPartitioner: Partitioners.LegacyPartitioner,
});

const prisma = new PrismaClient();

// var task = cron.schedule("* * * * *", async () => {
//   try {
//     await producer.connect();
//     console.log("running cron");
//     const allPatient = await prisma.patient.findMany();
//     console.log(JSON.stringify(allPatient, null, 4));
//     await producer.send({
//       topic: "patient1",
//       messages: [
//         {
//           value: `sent at => ${new Date().toISOString()} with value ${allPatient}`,
//         },
//       ],
//     });
//     await producer.disconnect();
//     await prisma.$disconnect();
//   } catch (error) {
//     console.log(error);
//     await prisma.$disconnect();
//   }
// });

const main = async () => {
  const allPatient = await prisma.patient.findMany({
    include: {
      doctor_order_print: true,
      opd_allergy: true,
      ovstdiag: true,
    },
  });

  const patientISP: patientISP[] = allPatient.map((patient) => {
    const contact: Contact = {
      name: patient.contact_name,
      uid: patient.contact_uid,
      relationship: patient.contact_relationship,
      gender: patient.contact_gender,
      telecom: patient.contact_telecom,
    };

    const isTaking: isTaking[] = patient.doctor_order_print.map((order) => {
      return {
        uid: order.hn,
        code: order.icode,
        authoredOn: order.createdAt,
        dosageInstruction: order.shortlist,
      };
    });

    const isAllergic: isAllergic[] = patient.opd_allergy.map((allergy) => {
      return {
        uid: allergy.hn,
        code: allergy.agent,
        criticality: allergy.seriousness,
        recordDate: allergy.createdAt,
      };
    });

    const isHaving: isHaving[] = patient.ovstdiag.map((diag) => {
      return {
        uid: diag.hn,
        code: diag.icd10_code,
        recordDate: diag.vstdate,
      };
    });

    return {
      uid: patient.hn,
      cid: patient.cid,
      name: `${patient.fname} ${patient.lname}`,
      brithdate: patient.birthday,
      gender: patient.contact_gender,
      telecom: patient.contact_telecom,
      contact: contact,
      isAllergic: isAllergic,
      isHaving: isHaving,
      isTaking: isTaking,
    };
  });

  console.log(JSON.stringify(patientISP, null, 4));
};

main();
