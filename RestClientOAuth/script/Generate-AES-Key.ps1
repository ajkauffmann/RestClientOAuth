az login
az keyvault secret show --vault-name bc-secret-vault --name restclient-key

$b = [byte[]]::new(32)
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
az keyvault secret set --vault-name bc-secret-vault --name restclient-key --value ([Convert]::ToBase64String($b)) -o none