import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import {TypeOrmModule} from '@nestjs/typeorm';
import { ConfigModule } from './modules/config/config.module';
import configuration from './config/configuration';


@Module({
  imports: [
    // ConfigModule.forRoot({isGlobal:true,
    // load :[configuration]
    // }),
    ConfigModule,
    // TypeOrmModule.forRoot({

    // })
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
