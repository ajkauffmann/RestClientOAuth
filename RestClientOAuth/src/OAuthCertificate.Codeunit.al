codeunit 50310 "OAuth Certificate KFM"
{
    var
        OAuthCertificateImpl: Codeunit "OAuth Certificate Impl. KFM";

    procedure SetCertificate(Value: Text)
    begin
        OAuthCertificateImpl.SetCertificate(Value);
    end;

    procedure GetCertificate() ReturnValue: Text
    begin
        ReturnValue := OAuthCertificateImpl.GetCertificate();
    end;

    procedure SetPrivateKey(Value: SecretText)
    begin
        OAuthCertificateImpl.SetPrivateKey(Value);
    end;

    procedure GetPrivateKey() ReturnValue: SecretText
    begin
        ReturnValue := OAuthCertificateImpl.GetPrivateKey();
    end;

    procedure HasValue(): Boolean
    begin
        exit(OAuthCertificateImpl.HasValue());
    end;

    procedure ThumbprintBase64() ReturnValue: Text
    begin
        ReturnValue := OAuthCertificateImpl.ThumbprintBase64();
    end;
}