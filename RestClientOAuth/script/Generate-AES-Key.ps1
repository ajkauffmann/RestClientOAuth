# Replace VAULT_NAME and KEY_NAME with the appropriate values
az login

$b = [byte[]]::new(32)
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
az keyvault secret set --vault-name VAULT_NAME --name KEY_NAME --value ([Convert]::ToBase64String($b)) -o none

# The generated AES key is stored as a secret in the specified Azure Key Vault
# The next line retrieves the stored AES key from the Azure Key Vault
# The AES key can be stored in a file resource
az keyvault secret show --vault-name VAULT_NAME --name KEY_NAME --query value -o table
