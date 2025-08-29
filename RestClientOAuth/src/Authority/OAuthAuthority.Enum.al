enum 50303 "OAuth Authority KFM" implements "OAuth Authority KFM"
{
    Extensible = true;

    value(1; MicrosoftEntraID)
    {
        Caption = 'Microsoft Entra ID';
        Implementation = "OAuth Authority KFM" = "Microsoft Entra ID KFM";
    }
}