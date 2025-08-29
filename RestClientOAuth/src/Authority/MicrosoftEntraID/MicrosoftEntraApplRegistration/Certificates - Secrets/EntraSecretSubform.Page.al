page 50301 "Entra Secret Subform KFM"
{
    PageType = ListPart;
    Caption = 'Secrets';
    ApplicationArea = All;
    SourceTable = "Entra Secret KFM";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Description; Rec.Description) { }
                field("End Date/Time"; Rec."End Date/Time") { }
                field(SecretTxt; SecretTxt)
                {
                    Caption = 'Value';
                    Editable = SecretEditable;

                    trigger OnValidate()
                    begin
                        Rec.Hint := SecretTxt.Substring(1, 3);
                        CurrPage.SaveRecord();
                        Rec.SetSecretText(SecretTxt);
                        CurrPage.Update(false);
                    end;
                }
                field(Id; Rec.Id) { }
            }
        }
    }

    var
        SecretTxt: Text;
        SecretEditable: Boolean;


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Id := Format(CreateGuid(), 0, 4).ToLower();
        SecretTxt := '';
        SecretEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Hint = '' then begin
            SecretTxt := '';
            SecretEditable := true;
        end else begin
            SecretTxt := Rec.Hint + '******************';
            SecretEditable := false;
        end;
    end;
}