import { getRepository } from 'typeorm';
import { Injectable } from '@nestjs/common';

import { AccountEntity } from 'src/account/infrastructure/entity/account.entity';

import {
  Account,
  AccountQuery,
  Accounts,
} from 'src/account/application/query/account.query';

@Injectable()
export class AccountQueryImplement implements AccountQuery {
  async find(offset: number, limit: number): Promise<Accounts> {
    return this.convertAccountsFromEntities(
      await getRepository(AccountEntity).find({ skip: offset, take: limit }),
    );
  }

  async findById(id: string): Promise<Account | undefined> {
    return this.convertAccountFromEntity(
      await getRepository(AccountEntity).findOne(id),
    );
  }

  private convertAccountFromEntity(
    entity?: AccountEntity,
  ): undefined | Account {
    return entity
      ? { ...entity, openedAt: entity.createdAt, closedAt: entity.deletedAt }
      : undefined;
  }

  private convertAccountsFromEntities(entities: AccountEntity[]): Accounts {
    return entities.map((entity) => ({
      ...entity,
      openedAt: entity.createdAt,
      closedAt: entity.deletedAt,
    }));
  }
}
