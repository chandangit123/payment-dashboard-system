import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Payment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;

  @Column()
  method: string;

  @Column()
  receiver: string;

  @Column()
  status: 'success' | 'failed' | 'pending';

  @CreateDateColumn()
  timestamp: Date;
}
