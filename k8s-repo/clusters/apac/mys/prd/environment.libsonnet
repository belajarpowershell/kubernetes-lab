(import '../factory.libsonnet')+
{
  environment: 'prd',
  keyVaultName: '',
  subscriptionID: '',
  veleroResourceGroup:'',
  backupstorage:'',
  listofClusters:[
    'mys-klcc-01',
    'mys-pjcc-01',

  ],
  
  externalSecrets: {
    encryptedData:{
        clientid:'',
        clientsecret:'',
        tenantid:'',

    }
  }

}
