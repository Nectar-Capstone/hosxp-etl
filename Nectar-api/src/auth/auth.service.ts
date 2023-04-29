import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { LoginBodyDto } from './dto/login.dto';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private prisma: PrismaService,
  ) {}

  async validateUser(username: string, pass: string): Promise<any> {
    const user = await this.prisma.credential.findUnique({
      where: { username: username },
    });
    const isMatch = await bcrypt.compare(pass, user.password);
    if (isMatch) {
      return {
        did: user.did,
        name: user.username,
      };
    }
    return null;
  }

  async login(loginDto: LoginBodyDto) {
    const { username } = loginDto;
    const user = await this.prisma.credential.findUnique({
      where: { username: username },
    });
    const payload = {
      did: user.did,
      name: user.username,
    };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
