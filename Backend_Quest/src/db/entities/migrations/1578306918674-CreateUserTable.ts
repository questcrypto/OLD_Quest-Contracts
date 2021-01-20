import MigrationUtil from 'src/utils/migrationUtil';
import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class CreateUserTable1578306918674 implements MigrationInterface {
    
    private static readonly table = new Table({
        
        name: 'UserTable',

        columns: [

          ...MigrationUtil.getIDColumn(),

          MigrationUtil.getVarCharColumn({name: 'name'}),

          MigrationUtil.getVarCharColumn({name: 'email'}),

        ],
    })
    public async up(queryRunner: QueryRunner): Promise<any> {        

    } 
    public async down(queryRunner: QueryRunner): Promise<any>  {       

    } 

}

