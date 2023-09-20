// Rios Engineer - Shared variable patterns
@description('Environment configuration JSON file. Loads env schema.')
var env = loadJsonContent('./configs/env-config.json')

@description('Define each organisational environment short prefix.')
var primaryPrefix = env.primary.prefix
var drPrefix = env.dr.prefix
var devPrefix = env.dev.prefix

module kv_prod 'br/public:security/keyvault:1.0.2' = {
   name: 'kv_deploy1'
   params:{
    location: env.primary.location
    prefix: primaryPrefix
   }
}

module kv_dr 'br/public:security/keyvault:1.0.2' = {
  name: 'kv_deploy21'
  params:{
   location: env.primary.location
   prefix: drPrefix
  }
}

module kv_dev 'br/public:security/keyvault:1.0.2' = {
  name: 'kv_deploy3'
  params:{
   location: env.primary.location
   prefix: devPrefix
  }
}

// Output KeyVault names
output prod string = kv_prod.name
output dr string = kv_dr.name
output dev string = kv_dev.name
