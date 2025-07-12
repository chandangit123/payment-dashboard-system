import { Controller, Get, Post, Body, Query, Param, Res, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { Payment } from './entities/payment.entity';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // ✅ Import guard
import { Response } from 'express'; // ✅ Needed for file download

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post()
  create(@Body() payment: Partial<Payment>) {
    return this.paymentsService.create(payment);
  }

  @Get()
  findAll(@Query() query) {
    return this.paymentsService.findAll(query);
  }

  @Get('stats')
  stats() {
    return this.paymentsService.stats();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.paymentsService.findOne(+id);
  }

  // ✅ Export endpoint to download CSV
  @UseGuards(JwtAuthGuard)
  @Get('export')
  async export(@Query() query, @Res() res: Response) {
    const csv = await this.paymentsService.exportAsCsv(query);
    res.header('Content-Type', 'text/csv');
    res.attachment('transactions.csv');
    res.send(csv);
  }
}
