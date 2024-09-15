# Sync to Azure Blob Storage Reusable Workflow

This GitHub Actions reusable workflow is designed to sync files from a local folder to an Azure Blob Storage container. It automates the upload process using flexible parameters for different storage accounts and containers.

## Requirements

To use this reusable workflow, you need:

1. **Azure Storage Account:** Ensure you have an Azure Storage Account set up to store the files.
2. **Azure Service Principal:** Create a Service Principal in Azure Active Directory that will be used for authentication in the workflow.
3. **Role Assignment:** Assign the "Storage Blob Data Contributor" role to the Service Principal on the Azure Storage Account. This role provides the necessary permissions to upload files to the storage container.
4. **PowerShell Script (`sync-to-azure.ps1`):** This script uses the Azure CLI to upload files to Azure Blob Storage. Ensure the script is compatible with PowerShell Core (`pwsh`).
5. **Azure CLI:** The workflow requires the Azure CLI to be installed on the runner. The `ubuntu-latest` runner used in the workflow already comes with the Azure CLI pre-installed.
6. **GitHub Secrets:** Store the Service Principal's client secret securely in your repository's GitHub Secrets (e.g., `CLIENT_SECRET`).

## Inputs

The reusable workflow accepts the following inputs:

- `storageAccountName` (string, required): The name of the Azure Storage account.
- `containerName` (string, required): The name of the Azure Blob Storage container.
- `localFolderPath` (string, required): The path to the local folder to sync.
- `tenantId` (string, required): The Azure tenant ID.
- `clientId` (string, required): The Azure client ID.
- `clientSecret` (secret, required): The Azure client secret.

## Usage Example

To use this reusable workflow, reference it in your workflow file as shown below:

```yaml
name: Sync to blob storage
on:
  push:
    branches:
      - master

jobs:
  sync-job:
    uses: ./.github/workflows/sync-to-blob.yml
    with:
      storageAccountName: "your-storage-account-name"
      containerName: "your-container-name"
      localFolderPath: "your-local-folder-path"
      tenantId: "your-tenant-id"
      clientId: "your-client-id"
      clientSecret: ${{ secrets.CLIENT_SECRET }}
