const cds = require('@sap/cds');

cds.on('bootstrap',app=> {
    app.get('/',(req,res)=>{
        res.send('CAP service is UP and running');
    });
});

cds.on('served',()=>{

});

cds.launch();