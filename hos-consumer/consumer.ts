import { Kafka } from "kafkajs";
import { PrismaClient } from "@prisma/client";

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:29092"],
});

const consumer = kafka.consumer({ groupId: "my-group" });
const prisma = new PrismaClient();

async function consumeMessages(topic) {
  await consumer.connect();
  await consumer.subscribe({ topic: topic });
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      // console.log({
      //   value: message.value.toString(),
      // });
      // '[{}]'
      const msg = JSON.parse(message.value.toString());
      console.log(typeof msg);

      // [{}]
      msg.forEach(async (data) => {
        const patient = patientData(data.patient);
        const isTaking = takingData(data.isTaking);
        const isAllergic = allergyData(data.isAllergic);
        const isHaving = havingData(data.isHaving);

        try {
          if (patient !== null)
            await prisma.patient.upsert({
              where: { uid: patient.uid },
              update: {},
              create: patient,
            });
          if (isTaking.length !== 0)
            await prisma.isTaking.createMany({ data: isTaking });
          if (isAllergic.length !== 0)
            await prisma.isAllergic.createMany({ data: isAllergic });
          if (isHaving.length !== 0)
            await prisma.isHaving.createMany({ data: isHaving });

          console.log(`Added`);
        } catch (error) {
          console.error(`Error storing patient : ${error}`);
        }

        //   consumer.disconnect();
      });
    },
  });
}

function patientData(patient) {
  var tempPatient = patient;
  tempPatient.birthdate = new Date(tempPatient.birthdate);
  return tempPatient;
}
function takingData(taking) {
  var tempTaking = taking;
  tempTaking.forEach((x) => (x.authoredOn = new Date(x.authoredOn)));
  return tempTaking;
}
function allergyData(allergy) {
  var tempAllergy = allergy;
  tempAllergy.forEach((x) => (x.recordDate = new Date(x.recordDate)));
  return tempAllergy;
}
function havingData(having) {
  var tempHaving = having;
  tempHaving.forEach((x) => (x.recordDate = new Date(x.recordDate)));
  return tempHaving;
}

consumeMessages("patient3");
