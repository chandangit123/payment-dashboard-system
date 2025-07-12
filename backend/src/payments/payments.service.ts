import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Payment } from './entities/payment.entity';
import { Parser } from 'json2csv'; // ✅ Import for CSV export

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment)
    private paymentRepo: Repository<Payment>,
  ) {}

  async create(paymentDto: Partial<Payment>) {
    const newPayment = this.paymentRepo.create(paymentDto);
    return this.paymentRepo.save(newPayment);
  }

  async findAll(query): Promise<Payment[]> {
    const where: any = {};
    if (query.status) where.status = query.status;
    if (query.method) where.method = query.method;
    if (query.from && query.to) {
      where.timestamp = Between(new Date(query.from), new Date(query.to));
    }
    return this.paymentRepo.find({
      where,
      order: { timestamp: 'DESC' },
      take: Number(query.limit) || 20,
      skip: Number(query.offset) || 0,
    });
  }

  async findOne(id: number) {
    return this.paymentRepo.findOneBy({ id });
  }

  async stats() {
    const [todayRevenue] = await this.paymentRepo.query(`
      SELECT COALESCE(SUM(amount),0) as total FROM payment
      WHERE status = 'success' AND DATE(timestamp) = CURRENT_DATE
    `);

    const [failedTxns] = await this.paymentRepo.query(`
      SELECT COUNT(*) as failed FROM payment WHERE status = 'failed'
    `);

    return {
      todayRevenue: Number(todayRevenue.total),
      failedTransactions: Number(failedTxns.failed),
    };
  }

  // ✅ CSV Export Logic
  async exportAsCsv(query): Promise<string> {
    const where: any = {};
    if (query.status) where.status = query.status;
    if (query.method) where.method = query.method;
    if (query.from && query.to) {
      where.timestamp = Between(new Date(query.from), new Date(query.to));
    }

    const payments = await this.paymentRepo.find({
      where,
      order: { timestamp: 'DESC' },
    });

    const fields = ['id', 'receiver', 'amount', 'method', 'status', 'timestamp'];
    const parser = new Parser({ fields });
    return parser.parse(payments);
  }
}
