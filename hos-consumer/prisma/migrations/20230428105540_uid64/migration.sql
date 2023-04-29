/*
  Warnings:

  - The primary key for the `IsAllergic` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `IsHaving` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `IsTaking` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Patient` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Practitioner` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- DropForeignKey
ALTER TABLE `IsAllergic` DROP FOREIGN KEY `fk_is_allergic_patient`;

-- DropForeignKey
ALTER TABLE `IsHaving` DROP FOREIGN KEY `fk_is_having_patient`;

-- DropForeignKey
ALTER TABLE `IsTaking` DROP FOREIGN KEY `fk_is_taking_patient`;

-- AlterTable
ALTER TABLE `IsAllergic` DROP PRIMARY KEY,
    MODIFY `uid` VARCHAR(64) NOT NULL,
    ADD PRIMARY KEY (`uid`, `code`);

-- AlterTable
ALTER TABLE `IsHaving` DROP PRIMARY KEY,
    MODIFY `uid` VARCHAR(64) NOT NULL,
    ADD PRIMARY KEY (`uid`, `code`);

-- AlterTable
ALTER TABLE `IsTaking` DROP PRIMARY KEY,
    MODIFY `uid` VARCHAR(64) NOT NULL,
    ADD PRIMARY KEY (`uid`, `code`);

-- AlterTable
ALTER TABLE `Patient` DROP PRIMARY KEY,
    MODIFY `uid` VARCHAR(64) NOT NULL,
    MODIFY `contact_uid` VARCHAR(64) NULL,
    ADD PRIMARY KEY (`uid`);

-- AlterTable
ALTER TABLE `Practitioner` DROP PRIMARY KEY,
    MODIFY `did` VARCHAR(64) NOT NULL,
    ADD PRIMARY KEY (`did`);

-- AddForeignKey
ALTER TABLE `IsAllergic` ADD CONSTRAINT `fk_is_allergic_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsHaving` ADD CONSTRAINT `fk_is_having_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsTaking` ADD CONSTRAINT `fk_is_taking_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;
