using { db } from '../db/schema';

service customservice {

entity UserData as projection on db.Users;
    

}