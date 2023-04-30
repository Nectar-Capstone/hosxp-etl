import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { Patient } from '@prisma/client';
import { JwtAuthGuard } from 'src/auth/guard/jwt-auth.guard';

@Controller('users')
export class UsersController {
  constructor(private userService: UsersService) {}

  @UseGuards(JwtAuthGuard)
  @Get('/patients')
  getPatient(): Promise<Patient[]> {
    return this.userService.findPatient();
  }

  @UseGuards(JwtAuthGuard)
  @Get('/patient')
  getOnePatient(@Query() query: { uid: string }): Promise<Patient> {
    return this.userService.findOne(query.uid);
  }
}
