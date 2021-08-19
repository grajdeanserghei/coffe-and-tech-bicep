az deployment sub create \
  --name coffe-tech-deployment-s2-dev \
  --location francecentral \
  --template-file main.bicep \
  --parameters env=dev \
        sqlConnectionString=SomeSecureConnectionString \
        location=francecentral