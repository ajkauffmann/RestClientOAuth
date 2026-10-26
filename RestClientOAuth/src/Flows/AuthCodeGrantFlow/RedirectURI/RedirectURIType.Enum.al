enum 50304 "Redirect URI Type KFM" implements "Redirect URI KFM"
{
    Extensible = true;
    DefaultImplementation = "Redirect URI KFM" = "Redirect URI None KFM";

    value(0; None)
    {
        Implementation = "Redirect URI KFM" = "Redirect URI None KFM";
    }
    value(1; "Built-in")
    {
        Implementation = "Redirect URI KFM" = "Redirect URI Built-in KFM";
    }
}