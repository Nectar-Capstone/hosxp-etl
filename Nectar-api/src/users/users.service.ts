import { Injectable } from '@nestjs/common';
import { Patient } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';

// This should be a real class/interface representing a user entity
export type User = any;

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findPatient(): Promise<Patient[]> {
    return this.prisma.patient.findMany({
      include: {
        IsAllergic: true,
        IsHaving: true,
        IsTaking: true,
      },
    });
  }

  async findOne(uid: string): Promise<Patient> {
    return this.prisma.patient.findUnique({
      where: {
        uid: uid,
      },
      include: {
        IsHaving: {
          include: {
            ConditionProblemDiagnosis: true,
          },
        },
        IsAllergic: {
          include: {
            AllergicIntoleranceSubstance: true,
          },
        },
        IsTaking: {
          include: {
            Medication: true,
          },
        },
      },
    });
  }
}
