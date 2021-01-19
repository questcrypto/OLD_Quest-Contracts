import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';
// import ConfigService from '../src/Services/config.service'
import { ConfigModule } from './modules/config/config.module';
import ConfigService from './Services/config.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  console.log(process.env.HTTP_PORT);
  // var configservice = app.get(ConfigService);
  // console.log(configservice.get('port', 4500));
  const configService = app.select(ConfigModule).get(ConfigService);

  let env = configService.getenvConfig();
  console.log(env.HTTP_PORT);
  await app.listen(env.HTTP_PORT);
}


bootstrap();
