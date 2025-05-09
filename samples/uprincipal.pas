unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edCNPJ: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  LazCNPJAlfaNumerico;

{$R *.lfm}

{ TfrPrincipal }

procedure TfrPrincipal.Button1Click(Sender: TObject);
begin
  if IsValidCNPJ(edCNPJ.Text) then
    ShowMessage('CNPJ válido')
  else
    ShowMessage('CNPJ inválido');
end;

procedure TfrPrincipal.Button2Click(Sender: TObject);
var
  LCnpj: String;
begin
  LCnpj := Trim(edCNPJ.Text);
  LCnpj := StringReplace(LCnpj, '.', '', [rfReplaceAll]);
  LCnpj := StringReplace(LCnpj, '/', '', [rfReplaceAll]);
  LCnpj := StringReplace(LCnpj, '-', '', [rfReplaceAll]);
  if Length(LCnpj) = 14 then
    LCnpj := Copy(LCnpj,1,12);
  ShowMessage(CalculateCNPJCheckDigits(LCnpj));
end;

end.

