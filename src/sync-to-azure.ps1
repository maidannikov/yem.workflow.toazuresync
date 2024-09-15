param (
    [string]$storageAccountName,
    [string]$containerName,
    [string]$localFolderPath,
    [string]$tenantId,
    [string]$clientId, #!!! Only if you are using service principal !!!
    [string]$clientSecret #!!! Only if you are using service principal !!!
)

#Log in to Azure CLI (Not necessary) !!! Only if you are using service principal !!!
Write-Output "Loggin in to Azure CLI"
az login --service-principal -u $clientId -p $clientSecret --tenant $tenantId

Write-Output "Syncing files from $localFolderPath to Azure Storage Account: $storageAccountName"

Write-Output "Creating container $containerName if it does not exist"
az storage container create --account-name $storageAccountName --name $containerName --auth-mode login

$rootPath = Get-Item -LiteralPath $localFolderPath
Write-Output "Root path: $rootPath"
Write-Output "Local folder path: $localFolderPath"


Write-Output "Uploading files to container $containerName"
Get-ChildItem -Recurse -File -Path $localFolderPath | ForEach-Object {
    $fileRelativePath = $_.FullName.Substring($rootPath.FullName.Length + 1).TrimStart('\')
    az storage blob upload --account-name $storageAccountName `
        --container-name $containerName `
        --name $fileRelativePath `
        --file $_.FullName `
        --overwrite `
        --no-progress `
        --only-show-errors `
        --auth-mode login # !!! Only if you are using service principal !!!
}

#Log out of Azure CLI(Not necessary) !!! Only if you are using service principal !!!
Write-Output "Loggin out of Azure CLI"
az logout
