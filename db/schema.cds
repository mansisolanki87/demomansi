namespace db;
using { managed } from '@sap/cds/common';

entity Users : managed {
    key userid:UUID;
    username:String;
}
