$Years = 5 # Number of years the certificate will be valid for
$CertificateName = "<CERTIFICATE NAME>" # Replace <CERTIFICATE NAME> with the desired certificate name
$SubjectName = "<SUBJECT>" # Replace <SUBJECT> with the desired certificate subject name

$policies = [System.Security.Cryptography.CngExportPolicies]::AllowPlaintextExport, [System.Security.Cryptography.CngExportPolicies]::AllowExport
$Certificate = New-SelfSignedCertificate `
               -CertStoreLocation Cert:\CurrentUser\My\ `
               -HashAlgorithm "SHA256" `
               -KeyLength 2048 `
               -KeyAlgorithm RSA `
               -KeyUsage DigitalSignature `
               -Subject $SubjectName `
               -FriendlyName $CertificateName `
               -KeyExportPolicy $policies `
               -NotBefore (Get-Date) `
               -NotAfter (Get-Date).AddYears($Years)
               
# The next line stores the certificate as a .cer file
# It can be used to upload to Azure App Registration
$cerFilePath = "C:\Temp\$($CertificateName).cer"
$Certificate | Export-Certificate -FilePath $cerFilePath

# The generated private key can be stored in a file resource
# or store it in an Azure Key Vault as a secret
# Example:
az keyvault secret set --vault-name VAULT_NAME --name CERT_NAME --value ($Certificate.PrivateKey.ToXmlString($true)) -o none
# The next line retrieves the private key as an XML string and prints it to the console
# $Certificate.PrivateKey.ToXmlString($true)

# Optionally export the certificate as a PFX file with the private key
$pfxFilePath = "C:\Temp\$($CertificateName).pfx"
$CertPasswd =  "<CERTIFICATE PASSWORD>" # Password for the certificate's private key export
$pfxPassword = ConvertTo-SecureString ($CertPasswd) -Force -AsPlainText
$Certificate | Export-PfxCertificate -FilePath $pfxFilePath -Password $pfxPassword

# Optionally remove the certificate from the store after exporting it
$Certificate | Remove-Item