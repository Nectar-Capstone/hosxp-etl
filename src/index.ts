import { PrismaClient } from "@prisma/client";
import cron from "node-cron";
import { Kafka } from "kafkajs";
import * as dotenv from "dotenv";
dotenv.config();

// var task = cron.schedule("* * * * *", async () => {
//   const prisma = new PrismaClient();
//   try {
//     const allPatient = await prisma.patient.findMany();
//     console.log(JSON.stringify(allPatient, null, 4));
//     await prisma.$disconnect();
//   } catch (error) {
//     console.log(error);
//     await prisma.$disconnect();
//   }
// });

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:29092"],
});

const producer = kafka.producer();

var task = cron.schedule("* * * * *", async () => {
  await producer.connect();
  console.log("running cron");
  await producer.send({
    topic: "test4",
    messages: [
      {
        value: `sent at => ${new Date().toISOString()}`,
      },
    ],
  });
  await producer.disconnect();
});

// const main = async () => {
//   const prisma = new PrismaClient();
//   const allPatient = await prisma.patient.findMany();
//   await producer.connect();
//   console.log("connected");
//   await producer.send({
//     topic: "test3",
//     messages: [
//       {
//         value: `at time: ${new Date().toUTCString()} => patient: ${JSON.stringify(
//           allPatient
//         )}`,
//       },
//     ],
//   });
//   await producer.disconnect();
// };

// main();
