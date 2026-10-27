$policies = [System.Security.Cryptography.CngExportPolicies]::AllowPlaintextExport, [System.Security.Cryptography.CngExportPolicies]::AllowExport
$Certificate = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My\ -HashAlgorithm "SHA256" -KeyLength 2048 -KeyAlgorithm RSA -KeyUsage DigitalSignature -Subject "PowerShell Self Signed" -KeyExportPolicy $policies

[Convert]::ToBase64String($Certificate.RawData)
$Certificate.PrivateKey.ToXmlString($true)