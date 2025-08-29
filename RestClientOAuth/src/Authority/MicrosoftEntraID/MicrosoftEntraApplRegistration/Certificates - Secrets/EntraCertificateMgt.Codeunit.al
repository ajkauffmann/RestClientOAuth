codeunit 50317 "Entra Certificate Mgt KFM"
{
    Access = Internal;

    var
        TimeHelper: Codeunit TimeHelper;
        SubjectNameTxt: Label 'CN=%1', Locked = true;

    procedure CreateSelfSignedCertificate(SubjectName: Text; ExpiryDate: Date) EntraCertificate: Record "Entra Certificate KFM";
    begin
        EntraCertificate.Init();
        EntraCertificate.Name := SubjectName;
        EntraCertificate."Expiry Date" := TimeHelper.GetDateTimeInUtc(CreateDateTime(ExpiryDate, 000000T));
        CreateSelfSignedCertificate(EntraCertificate);
    end;

    procedure CreateSelfSignedCertificate(var EntraCertificate: Record "Entra Certificate KFM")
    var
        CertificateRequest: Codeunit CertificateRequest;
        PrivateKey: Text;
        CertBase64: Text;
    begin
        EntraCertificate.TestField(Name);
        EntraCertificate.TestField("Expiry Date");

        CertificateRequest.InitializeRSA(2048, true, PrivateKey);
        CertificateRequest.InitializeCertificateRequestUsingRSA(StrSubstNo(SubjectNameTxt, EntraCertificate.Name), Enum::"Hash Algorithm"::SHA256, Enum::"RSA Signature Padding"::Pkcs1);
        CertificateRequest.AddX509KeyUsageToCertificateRequest(128, true); // 128 = Digital Signature | Docs: https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.x509certificates.x509keyusageflags
        CertificateRequest.CreateSelfSigned(TimeHelper.GetDateTimeInUtc(CreateDateTime(Today, 000000T)), TimeHelper.GetDateTimeInUtc(EntraCertificate."Expiry Date"), Enum::"X509 Content Type"::Cert, CertBase64);
        EntraCertificate.SetCertificate(CertBase64);
        EntraCertificate.SetPrivateKey(PrivateKey);
    end;
}