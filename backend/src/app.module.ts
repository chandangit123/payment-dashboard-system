import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';

import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module'; // ✅ UsersModule import
import { PaymentsModule } from './payments/payments.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql', // or 'postgres'
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: 'chandanmysql123#', // ⚠️ Replace with environment variable in production
      database: 'payment_dashboard',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: false, // ⚠️ Set to false in production
    }),
    AuthModule,
    UsersModule,     // ✅ UsersModule added before PaymentsModule
    PaymentsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
