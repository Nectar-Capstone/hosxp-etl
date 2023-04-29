-- CreateTable
CREATE TABLE `AllergicIntoleranceSubstance` (
    `code` VARCHAR(255) NOT NULL,
    `display` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ConditionProblemDiagnosis` (
    `code` VARCHAR(255) NOT NULL,
    `display` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `IsAllergic` (
    `uid` VARCHAR(64) NOT NULL,
    `code` VARCHAR(255) NOT NULL,
    `clinicalStatus` VARCHAR(255) NULL,
    `verificationStatus` VARCHAR(255) NULL,
    `type` VARCHAR(255) NULL,
    `category` VARCHAR(255) NULL,
    `criticality` VARCHAR(255) NULL,
    `recordDate` DATE NULL,

    INDEX `fk_is_allergic_substance`(`code`),
    PRIMARY KEY (`uid`, `code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `IsHaving` (
    `uid` VARCHAR(64) NOT NULL,
    `code` VARCHAR(255) NOT NULL,
    `clinicalStatus` VARCHAR(255) NULL,
    `verificationStatus` VARCHAR(255) NULL,
    `category` VARCHAR(255) NULL,
    `severity` VARCHAR(255) NULL,
    `recordDate` DATE NULL,

    INDEX `fk_is_having_diagnosis`(`code`),
    PRIMARY KEY (`uid`, `code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `IsTaking` (
    `uid` VARCHAR(64) NOT NULL,
    `code` VARCHAR(255) NOT NULL,
    `authoredOn` DATE NULL,
    `dosageInstruction` VARCHAR(255) NULL,
    `note` VARCHAR(255) NULL,

    INDEX `fk_is_taking_medication`(`code`),
    PRIMARY KEY (`uid`, `code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Medication` (
    `code` VARCHAR(255) NOT NULL,
    `display` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Organization` (
    `oid` INTEGER NOT NULL,
    `type` VARCHAR(255) NULL,
    `name` VARCHAR(255) NOT NULL,
    `address` VARCHAR(255) NULL,
    `telecom` VARCHAR(255) NULL,
    `partOf` INTEGER NULL,

    INDEX `fk_organization_partof`(`partOf`),
    PRIMARY KEY (`oid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Patient` (
    `uid` VARCHAR(64) NOT NULL,
    `cid` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `gender` VARCHAR(10) NULL,
    `telecom` VARCHAR(255) NULL,
    `contact_name` VARCHAR(255) NOT NULL,
    `contact_relationship` VARCHAR(255) NOT NULL,
    `contact_gender` VARCHAR(10) NULL,
    `contact_telecom` VARCHAR(255) NOT NULL,
    `birthdate` DATE NULL,

    PRIMARY KEY (`uid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Practitioner` (
    `did` VARCHAR(64) NOT NULL,
    `name` VARCHAR(255) NULL,
    `gender` VARCHAR(10) NULL,
    `telecom` VARCHAR(255) NULL,
    `oid` INTEGER NOT NULL,
    `since` DATE NULL,
    `until` DATE NULL,
    `code` VARCHAR(255) NULL,

    INDEX `fk_practitioner_organization`(`oid`),
    PRIMARY KEY (`did`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `credential` (
    `username` VARCHAR(64) NOT NULL,
    `password` VARCHAR(64) NULL,
    `did` VARCHAR(64) NULL,
    `updatedAt` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `createdAt` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `did`(`did`),
    PRIMARY KEY (`username`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `isAccess` (
    `uid` VARCHAR(64) NOT NULL,
    `did` VARCHAR(64) NOT NULL,
    `latitide` VARCHAR(64) NULL,
    `longtitiude` VARCHAR(64) NULL,
    `actime` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `practitioner_idx`(`did`),
    PRIMARY KEY (`uid`, `did`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `IsAllergic` ADD CONSTRAINT `fk_is_allergic_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsAllergic` ADD CONSTRAINT `fk_is_allergic_substance` FOREIGN KEY (`code`) REFERENCES `AllergicIntoleranceSubstance`(`code`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsHaving` ADD CONSTRAINT `fk_is_having_diagnosis` FOREIGN KEY (`code`) REFERENCES `ConditionProblemDiagnosis`(`code`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsHaving` ADD CONSTRAINT `fk_is_having_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsTaking` ADD CONSTRAINT `fk_is_taking_medication` FOREIGN KEY (`code`) REFERENCES `Medication`(`code`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `IsTaking` ADD CONSTRAINT `fk_is_taking_patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Organization` ADD CONSTRAINT `fk_organization_partof` FOREIGN KEY (`partOf`) REFERENCES `Organization`(`oid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Practitioner` ADD CONSTRAINT `fk_practitioner_organization` FOREIGN KEY (`oid`) REFERENCES `Organization`(`oid`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `credential` ADD CONSTRAINT `credential_ibfk_1` FOREIGN KEY (`did`) REFERENCES `Practitioner`(`did`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `isAccess` ADD CONSTRAINT `patient` FOREIGN KEY (`uid`) REFERENCES `Patient`(`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `isAccess` ADD CONSTRAINT `practitioner` FOREIGN KEY (`did`) REFERENCES `Practitioner`(`did`) ON DELETE NO ACTION ON UPDATE NO ACTION;

