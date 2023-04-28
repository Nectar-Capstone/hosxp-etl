-- CreateTable
CREATE TABLE `DoctorOrderPrint` (
    `doctor_order_print_code` INTEGER NOT NULL AUTO_INCREMENT,
    `doctor_code` VARCHAR(191) NULL,
    `drug_name` VARCHAR(191) NULL,
    `shortlist` VARCHAR(191) NULL,
    `doctor_name` VARCHAR(191) NULL,
    `icode` VARCHAR(191) NULL,
    `hn` VARCHAR(191) NULL,
    `createdAt` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `DoctorOrderPrint_hn_fkey`(`hn`),
    INDEX `DoctorOrderPrint_icode_fkey`(`icode`),
    PRIMARY KEY (`doctor_order_print_code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `DrugItem` (
    `icode` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NULL,
    `strength` VARCHAR(191) NULL,
    `units` VARCHAR(191) NULL,
    `unitprice` DOUBLE NULL,
    `dosageform` VARCHAR(191) NULL,
    `criticalpriority` VARCHAR(191) NULL,
    `drugaccount` VARCHAR(191) NULL,
    `drugcategory` VARCHAR(191) NULL,

    PRIMARY KEY (`icode`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Icd10` (
    `icd10_code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `spclty` VARCHAR(191) NULL,
    `tname` VARCHAR(191) NULL,
    `code3` VARCHAR(191) NULL,
    `code4` VARCHAR(191) NULL,
    `code5` VARCHAR(191) NULL,
    `sex` VARCHAR(191) NOT NULL,
    `ipd_valid` VARCHAR(191) NULL,
    `icd10compat` VARCHAR(191) NULL,
    `icd10tmcompat` VARCHAR(191) NULL,
    `active_status` VARCHAR(191) NULL,
    `hos_guid` VARCHAR(191) NULL,
    `hos_guid_ext` VARCHAR(191) NULL,

    PRIMARY KEY (`icd10_code`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OpdAllergy` (
    `hn` VARCHAR(191) NOT NULL,
    `report_date` DATETIME(3) NULL,
    `agent` VARCHAR(191) NOT NULL,
    `symptom` VARCHAR(191) NULL,
    `reporter` VARCHAR(191) NULL,
    `note` VARCHAR(191) NULL,
    `seriousness` VARCHAR(191) NULL,
    `createdAt` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `allergy_agent_idx`(`agent`),
    PRIMARY KEY (`hn`, `agent`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OvstDiag` (
    `ovst_diag_id` INTEGER NOT NULL AUTO_INCREMENT,
    `icd10_code` VARCHAR(191) NULL,
    `hn` VARCHAR(191) NULL,
    `vstdate` DATETIME(3) NULL,
    `vsttime` DATETIME(3) NULL,
    `createdAt` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `OvstDiag_hn_fkey`(`hn`),
    INDEX `OvstDiag_icd10_code_fkey`(`icd10_code`),
    PRIMARY KEY (`ovst_diag_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Patient` (
    `hn` VARCHAR(191) NOT NULL,
    `cid` VARCHAR(45) NULL,
    `pname` VARCHAR(191) NULL,
    `fname` VARCHAR(191) NULL,
    `lname` VARCHAR(191) NULL,
    `birthday` DATETIME(3) NULL,
    `bloodgrp` VARCHAR(191) NULL,
    `nationality` VARCHAR(191) NULL,
    `sex` VARCHAR(191) NULL,
    `citizenship` VARCHAR(191) NULL,
    `bloodgroup_rh` VARCHAR(191) NULL,
    `createdAt` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `contact_telecom` VARCHAR(45) NULL,
    `contact_gender` VARCHAR(45) NULL,
    `contact_relationship` VARCHAR(45) NULL,
    `contact_name` VARCHAR(45) NULL,

    PRIMARY KEY (`hn`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AllergyAgent` (
    `id` VARCHAR(10) NOT NULL,
    `name` VARCHAR(50) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `DoctorOrderPrint` ADD CONSTRAINT `DoctorOrderPrint_hn_fkey` FOREIGN KEY (`hn`) REFERENCES `Patient`(`hn`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DoctorOrderPrint` ADD CONSTRAINT `DoctorOrderPrint_icode_fkey` FOREIGN KEY (`icode`) REFERENCES `DrugItem`(`icode`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OpdAllergy` ADD CONSTRAINT `OpdAllergy_hn_fkey` FOREIGN KEY (`hn`) REFERENCES `Patient`(`hn`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OpdAllergy` ADD CONSTRAINT `allergy_agent` FOREIGN KEY (`agent`) REFERENCES `AllergyAgent`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `OvstDiag` ADD CONSTRAINT `OvstDiag_hn_fkey` FOREIGN KEY (`hn`) REFERENCES `Patient`(`hn`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OvstDiag` ADD CONSTRAINT `OvstDiag_icd10_code_fkey` FOREIGN KEY (`icd10_code`) REFERENCES `Icd10`(`icd10_code`) ON DELETE SET NULL ON UPDATE CASCADE;

