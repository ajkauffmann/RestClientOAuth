/// <summary>
/// Protects certificate private keys and client secrets at rest with an app-held AES-256 key.
///
/// The key is read from a private extension resource (resourceFolders), so it
/// lives in the app package, never in the database. A copied or exported
/// environment therefore holds only inert ciphertext: the platform's shared
/// environment encryption key cannot decrypt it, and no other extension can
/// read this extension's private resource. Harden resourceExposurePolicy in
/// app.json so the key resource is not downloadable from the running tenant.
/// </summary>
codeunit 50300 "Data Encryption Helper KFM"
{
    Access = Internal;

    var
        KeyResourceNameTxt: Label 'data.key', Locked = true;
        SeparatorTok: Label '|', Locked = true;
        MalformedValueErr: Label 'The stored private key is not in the expected protected format.';

    /// <summary>
    /// Encrypts a private key for storage. Returns "base64(IV)|base64(ciphertext)".
    /// A fresh random IV is used for every call so identical keys never produce
    /// identical ciphertext under the single data key.
    /// </summary>
    [NonDebuggable]
    internal procedure Encrypt(PlainText: Text) StoredValue: Text
    var
        Rijndael: Codeunit "Rijndael Cryptography";
        DataKey: SecretText;
        DiscardKey: SecretText;
        IVBase64: Text;
        CipherBase64: Text;
    begin
        if PlainText = '' then
            exit('');

        DataKey := GetDataKey();

        Rijndael.InitRijndaelProvider(); // AES-256-CBC/PKCS7 with a CSPRNG key + IV
        Rijndael.GetEncryptionData(DiscardKey, IVBase64); // keep only the random IV
        Rijndael.SetEncryptionData(DataKey, IVBase64); // swap in our app-held key

        CipherBase64 := Rijndael.Encrypt(PlainText);
        StoredValue := IVBase64 + SeparatorTok + CipherBase64;
    end;

    /// <summary>
    /// Decrypts a value produced by Encrypt back into SecretText.
    /// </summary>
    [NonDebuggable]
    internal procedure Decrypt(StoredValue: Text) ReturnValue: SecretText
    var
        Rijndael: Codeunit "Rijndael Cryptography";
        CallerMustBeSameModuleErr: Label 'Decrypt can only be called from the same module that owns the data key.';
        ThisModule: ModuleInfo;
        CallingModule: ModuleInfo;
        DataKey: SecretText;
        IVBase64: Text;
        CipherBase64: Text;
        SeparatorPos: Integer;
    begin
        NavApp.GetCallerModuleInfo(CallingModule);
        NavApp.GetCurrentModuleInfo(ThisModule);

        if CallingModule.Id <> ThisModule.Id then
            Error(CallerMustBeSameModuleErr);

        if StoredValue = '' then
            exit;

        SeparatorPos := StrPos(StoredValue, SeparatorTok);
        if SeparatorPos <= 1 then
            Error(MalformedValueErr);

        IVBase64 := CopyStr(StoredValue, 1, SeparatorPos - 1);
        CipherBase64 := CopyStr(StoredValue, SeparatorPos + StrLen(SeparatorTok));

        DataKey := GetDataKey();

        Rijndael.InitRijndaelProvider();
        Rijndael.SetEncryptionData(DataKey, IVBase64);

        ReturnValue := Rijndael.Decrypt(CipherBase64);
    end;

    /// <summary>
    /// Returns true when the value is already in the protected "base64(IV)|base64(ciphertext)"
    /// format produced by Encrypt. Legacy plaintext keys and secrets are base64/PEM and never
    /// contain the separator, so this reliably distinguishes migrated from unmigrated values.
    /// Used by the data-migration upgrade to skip values that are already protected.
    /// </summary>
    internal procedure IsProtected(StoredValue: Text): Boolean
    begin
        exit(StrPos(StoredValue, SeparatorTok) > 1);
    end;

    [NonDebuggable]
    local procedure GetDataKey() DataKey: SecretText
    begin
        DataKey := NavApp.GetResourceAsText(KeyResourceNameTxt);
    end;
}
