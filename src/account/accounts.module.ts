import { Logger, Module, Provider } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';

import { AccountRepositoryImplement } from './infrastructure/repository/account.repository';
import { IntegrationEventPublisherImplement } from './infrastructure/message/integration-event.publisher';
import { EventStoreImplement } from "./infrastructure/cache/event-store";

import { CloseAccountHandler } from 'src/account/application/command/close-account.handler';
import { DepositHandler } from 'src/account/application/command/deposit.handler';
import { OpenAccountHandler } from 'src/account/application/command/open-account.handler';
import { RemitHandler } from 'src/account/application/command/remit.handler';
import { UpdatePasswordHandler } from 'src/account/application/command/update-password.handler';
import { WithdrawHandler } from 'src/account/application/command/withdraw.handler';
import { AccountClosedHandler } from 'src/account/application/event/account-closed.handler';
import { AccountOpenedHandler } from 'src/account/application/event/account-opened.handler';
import { DepositedHandler } from 'src/account/application/event/deposited.handler';
import { PasswordUpdatedHandler } from 'src/account/application/event/password-updated.handler';
import { WithdrawnHandler } from 'src/account/application/event/withdrawn.handler';

import { AccountService } from 'src/account/domain/service';
import { AccountFactory } from 'src/account/domain/factory';
import { InjectionToken } from './application/injection.token';

const infrastructure: Provider[] = [
  {
    provide: InjectionToken.ACCOUNT_REPOSITORY,
    useClass: AccountRepositoryImplement,
  },
  {
    provide: InjectionToken.INTEGRATION_EVENT_PUBLISHER,
    useClass: IntegrationEventPublisherImplement,
  },
  {
    provide: InjectionToken.EVENT_STORE,
    useClass: EventStoreImplement,
  },
];

const domain = [AccountService, AccountFactory];

const application = [
  CloseAccountHandler,
  DepositHandler,
  OpenAccountHandler,
  RemitHandler,
  UpdatePasswordHandler,
  WithdrawHandler,
  AccountClosedHandler,
  AccountOpenedHandler,
  DepositedHandler,
  PasswordUpdatedHandler,
  WithdrawnHandler,
];

@Module({
  imports: [CqrsModule],
  providers: [Logger, ...infrastructure, ...application, ...domain],
})
export class AccountsModule {}
