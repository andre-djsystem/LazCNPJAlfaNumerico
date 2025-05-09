unit LazCNPJAlfaNumerico;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

/// Verifica se um CNPJ (numérico ou alfanumérico) é válido segundo a NT 2025.001 v1.00
function IsValidCNPJ(const ACNPJ: string): Boolean;

/// Calcula os dígitos verificadores de um CNPJ alfanumérico de 12 caracteres
/// @raises Exception se a base não cumprir o formato esperado
function CalculateCNPJCheckDigits(const ABaseCNPJ: string): string;

implementation

const
  CNPJBaseSize  = 12;
  CNPJTotalSize = 14;
  CNPJZeroMask  = '00000000000000';
  // Pesos para cálculo dos dígitos verificadores (DV)
  PesosDV: array[0..12] of Integer = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
  // Letras proibidas na raiz do CNPJ alfanumérico conforme NT 2025.001 v1.00
  ExcludedLetters = ['F','I','O','Q','U'];

{ Remove pontos, barras e traços }
function RemoveFormatting(const S: string): string;
begin
  Result := Trim(S);
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

{ Verifica caracteres da base (12 primeiros): dígito ou letra não excluída }
function IsAllowedBaseChar(C: Char): Boolean;
begin
  C := UpCase(C);
  // dígitos sempre permitidos
  if C in ['0'..'9'] then
    Exit(True);
  // letras permitidas se não estiverem na lista de exclusão
  Result := (C in ['A'..'Z']) and not (C in ExcludedLetters);
end;

{ Retorna True se todos caracteres forem zeros }
function IsAllZeros(const S: string): Boolean;
var
  I: Integer;
begin
  if S = '' then Exit(False);
  for I := 1 to Length(S) do
    if S[I] <> '0' then Exit(False);
  Result := True;
end;

{ Verifica formato sem DV (12 caracteres alfanuméricos permitidos) }
function IsFormationValidWithoutDV(const CNPJ: string): Boolean;
var
  I: Integer;
begin
  Result := Length(CNPJ) = CNPJBaseSize;
  if not Result or (CNPJ = Copy(CNPJZeroMask, 1, CNPJBaseSize)) then
    Exit(False);
  for I := 1 to CNPJBaseSize do
    if not IsAllowedBaseChar(CNPJ[I]) then
      Exit(False);
  Result := True;
end;

{ Verifica formato com DV (12 alfanum + 2 dígitos) }
function IsFormationValidWithDV(const CNPJ: string): Boolean;
var
  I: Integer;
begin
  Result := Length(CNPJ) = CNPJTotalSize;
  if not Result or (CNPJ = CNPJZeroMask) then
    Exit(False);
  // primeiros 12 alfanum
  for I := 1 to CNPJBaseSize do
    if not IsAllowedBaseChar(CNPJ[I]) then
      Exit(False);
  // últimos 2 apenas dígitos
  for I := CNPJBaseSize + 1 to CNPJTotalSize do
    if not (CNPJ[I] in ['0'..'9']) then
      Exit(False);
  Result := True;
end;

{ Calcula um dígito verificador para a string fornecida }
function CalculateDigit(const CNPJ: string): Integer;
var
  Sum, I, PesoIndex: Integer;
  ch: Char;
begin
  Sum := 0;
  for I := Length(CNPJ) downto 1 do
  begin
    PesoIndex := Length(PesosDV) - Length(CNPJ) + (I - 1);
    ch := UpCase(CNPJ[I]);
    Sum += (Ord(ch) - Ord('0')) * PesosDV[PesoIndex];
  end;
  if (Sum mod 11) < 2 then
    Result := 0
  else
    Result := 11 - (Sum mod 11);
end;

function CalculateCNPJCheckDigits(const ABaseCNPJ: string): string;
var
  Base, dv1, dv2: string;
begin
  Base := RemoveFormatting(ABaseCNPJ);
  if not IsFormationValidWithoutDV(Base) then
    raise Exception.CreateFmt('Base CNPJ inválida para cálculo do DV: %s', [ABaseCNPJ]);
  dv1 := IntToStr(CalculateDigit(Base));
  dv2 := IntToStr(CalculateDigit(Base + dv1));
  Result := dv1 + dv2;
end;

function IsValidCNPJ(const ACNPJ: string): Boolean;
var
  Raw, ProvidedDV, CalcDV: string;
begin
  Raw := RemoveFormatting(ACNPJ);
  if not IsFormationValidWithDV(Raw) then
    Exit(False);
  ProvidedDV := Copy(Raw, CNPJBaseSize + 1, 2);
  CalcDV := CalculateCNPJCheckDigits(Copy(Raw, 1, CNPJBaseSize));
  Result := ProvidedDV = CalcDV;
end;

end.
