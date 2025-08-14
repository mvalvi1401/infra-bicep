param location string = resourceGroup().location
param storageName string = 'prodstorage${uniqueString(resourceGroup().id)}'
