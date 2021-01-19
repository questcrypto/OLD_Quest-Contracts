import { BaseEntity, Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

 @Entity({name: 'UserTable'})

class UserEntity extends BaseEntity {

 @PrimaryGeneratedColumn()

  id: number;

  @Column()

  name: string;

  @Column()

  email: string;

}

 export default UserEntity;