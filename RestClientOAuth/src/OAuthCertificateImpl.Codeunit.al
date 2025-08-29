codeunit 50311 "OAuth Certificate Impl. KFM"
{
    Access = Internal;

    var
        Certificate: Text;
        PrivateKey: SecretText;

    procedure SetCertificate(Value: Text)
    begin
        Certificate := Value;
    end;

    procedure GetCertificate() ReturnValue: Text
    begin
        ReturnValue := Certificate;
    end;

    procedure SetPrivateKey(Value: SecretText)
    begin
        PrivateKey := Value;
    end;

    procedure GetPrivateKey() ReturnValue: SecretText
    begin
        ReturnValue := PrivateKey;
    end;

    procedure HasValue(): Boolean
    begin
        exit(Certificate <> '');
    end;

    procedure ThumbprintBase64() ReturnValue: Text
    var
        X509Certificate2: Codeunit X509Certificate2;
        ThumbprintHex: Text;
    begin
        X509Certificate2.GetCertificateThumbprint(Certificate, SecretStrSubstNo(''), ThumbprintHex);
        ReturnValue := ConvertHexToBase64Text(ThumbprintHex);
    end;

    local procedure ConvertHexToBase64Text(Input: Text) Base64Text: Text
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
        OutStream: OutStream;
        ByteList: List of [Byte];
        Byte: Byte;
    begin
        ByteList := ConvertHexToByteList(Input);

        TempBlob.CreateOutStream(OutStream);
        foreach Byte in ByteList do
            OutStream.Write(Byte);

        TempBlob.CreateInStream(InStream);
        Base64Text := Base64Convert.ToBase64(InStream);
    end;

    local procedure ConvertHexToByteList(Input: Text) Output: List of [Byte]
    var
        InputList: List of [Text];
        Hex: Text[2];
        Char1, Char2 : Integer;
        i: Integer;
    begin
        for i := 1 to StrLen(Input) do begin
            InputList.Add(CopyStr(Input, i, 2));
            i += 1;
        end;

        foreach Hex in InputList do begin
            Char1 := HexToInt(CopyStr(Hex, 1, 1)) * 16;
            Char2 := HexToInt(CopyStr(Hex, 2, 1));
            Output.Add(Char1 + Char2);
        end;
    end;

    local procedure HexToInt(Hex: Text[1]) Int: Integer
    begin
        case Hex.ToUpper() of
            '0':
                Int := 0;
            '1':
                Int := 1;
            '2':
                Int := 2;
            '3':
                Int := 3;
            '4':
                Int := 4;
            '5':
                Int := 5;
            '6':
                Int := 6;
            '7':
                Int := 7;
            '8':
                Int := 8;
            '9':
                Int := 9;
            'A':
                Int := 10;
            'B':
                Int := 11;
            'C':
                Int := 12;
            'D':
                Int := 13;
            'E':
                Int := 14;
            'F':
                Int := 15;
        end;
    end;
}