table 50303 "Entra Certificate KFM"
{
    Caption = 'Certificate';
    DataPerCompany = false;
    ReplicateData = false;
    Access = Internal;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(11; "Expiry Date"; DateTime)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(12; "Private Key"; Blob)
        {
            Caption = 'Private Key';
            DataClassification = CustomerContent;
            Access = Local;
        }
        field(13; Certificate; Blob)
        {
            Caption = 'Certificate';
            DataClassification = CustomerContent;
            Access = Local;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    var
        CertCodeTxt: Label 'CERT', Locked = true;

    trigger OnInsert()
    begin
        if Rec.Code = '' then
            Rec.Code := GetNextCode();
    end;

    procedure IsExpired(): Boolean
    begin
        exit(Rec."Expiry Date" < CurrentDateTime);
    end;

    local procedure GetNextCode() ReturnValue: Code[10]
    begin
        ReturnValue := CertCodeTxt;
        ReturnValue := ReturnValue + Format(GetNextNumber()).PadLeft(MaxStrLen(ReturnValue) - StrLen(ReturnValue), '0');
    end;

    local procedure GetNextNumber() NextNumber: BigInteger
    begin
        if not NumberSequence.Exists(CertCodeTxt, false) then
            NumberSequence.Insert(CertCodeTxt, 0, 1, false);

        NextNumber := NumberSequence.Next(CertCodeTxt, false);
    end;

    internal procedure CreateCertificate()
    var
        EntraCertificateMgt: Codeunit "Entra Certificate Mgt KFM";
    begin
        EntraCertificateMgt.CreateSelfSignedCertificate(Rec);
        Rec.Modify();
    end;

    [NonDebuggable]
    internal procedure SetCertificate(Value: Text)
    var
        OutStream: OutStream;
    begin
        Rec.Certificate.CreateOutStream(OutStream);
        OutStream.WriteText(Value);
    end;

    [NonDebuggable]
    internal procedure GetCertificate() ReturnValue: Text
    var
        InStream: InStream;
    begin
        if not Rec.Certificate.HasValue then
            exit;

        Rec.Certificate.CreateInStream(InStream);
        InStream.ReadText(ReturnValue);
        if ReturnValue = '' then begin
            Rec.CalcFields(Certificate);
            Rec.Certificate.CreateInStream(InStream);
            InStream.ReadText(ReturnValue);
        end
    end;

    internal procedure DownloadCertificate()
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        Filename: Text;
        CertFileFilterTxt: Label 'Certificate File(*.cer)|*.cer';
        ExportCertificateFileDialogTxt: Label 'Choose the location where you want to save the certificate file.';
    begin
        TempBlob.FromRecord(Rec, Rec.FieldNo(Certificate));
        TempBlob.CreateInStream(InStream);
        Filename := Name + '.cer';
        if not DownloadFromStream(InStream, ExportCertificateFileDialogTxt, '', CertFileFilterTxt, Filename) then
            if GetLastErrorText() <> '' then
                Error(GetLastErrorText());
    end;

    internal procedure HasValue() ReturnValue: Boolean
    begin
        ReturnValue := Rec."Private Key".HasValue and Rec.Certificate.HasValue;
    end;

    [NonDebuggable]
    internal procedure SetPrivateKey(Value: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Private Key".CreateOutStream(OutStream);
        OutStream.WriteText(Value);
    end;

    internal procedure GetPrivateKey() ReturnValue: SecretText
    var
        InStream: InStream;
        [NonDebuggable]
        Value: Text;
    begin
        if not Rec."Private Key".HasValue then
            exit;

        Rec."Private Key".CreateInStream(InStream);
        InStream.ReadText(Value);
        if Value = '' then begin
            Rec.CalcFields("Private Key");
            Rec."Private Key".CreateInStream(InStream);
            InStream.ReadText(Value);
        end;
        ReturnValue := Value;
    end;

    internal procedure ThumbprintBase64() ReturnValue: Text
    var
        X509Certificate2: Codeunit X509Certificate2;
        ThumbprintHex: Text;
    begin
        X509Certificate2.GetCertificateThumbprint(GetCertificate(), SecretStrSubstNo(''), ThumbprintHex);
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