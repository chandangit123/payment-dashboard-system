// src/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './constants';
import { UsersModule } from '../users/users.module'; // ✅ Import UsersModule

@Module({
  imports: [
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '1d' },
    }),
    UsersModule, // ✅ Add this line
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}

