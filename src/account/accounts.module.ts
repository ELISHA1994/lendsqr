import { Logger, Module, Provider } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';

import { AccountService } from 'src/account/domain/service';
import { AccountFactory } from 'src/account/domain/factory';

const domain = [AccountService, AccountFactory];

@Module({
  imports: [CqrsModule],
  providers: [Logger, ...domain],
})
export class AccountsModule {}
