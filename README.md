# LazCNPJAlfaNumerico
Rotina para validação do CNPJ com base na Instrução Normativa RFB nº 2229, de 15 de outubro de 2024

## 🔍 Funcionalidades

* Validação de CNPJ numérico ou alfanumérico de 12 dígitos na raiz e 2 dígitos verificadores (DV)
* Suporte a letras maiúsculas na raiz, excluindo `F`, `I`, `O`, `Q` e `U`
* Remoção automática de máscara (`.` `/` `-`)
* Cálculo de DV pelo método módulo 11 (ASCII–48 e pesos definidos)

## ⭕ Pré-requisitos

* Lazarus 2.x / Free Pascal 3.x

## ⚙️ Instalação

Instalação via BOSS:

```sh
boss install https://github.com/andre-djsystem/LazCNPJAlfaNumerico
```

### Instalação manual

Adicione o diretório da unit ao seu *Unit search path* do projeto:

```
path/to/LazCNPJAlfaNumerico/src
```

E inclua em *Project > Project Options > Paths > Other unit files (-Fu)*.

## 🚀 Quickstart

### Validar um CNPJ

```pascal
uses
  LazCNPJAlfaNumerico;

begin
  if IsValidCNPJ('12.345.6A8/0001-95') then
    WriteLn('CNPJ válido')
  else
    WriteLn('CNPJ inválido');
end.
```

### Calcular dígitos verificadores (DV)

```pascal
uses
  LazCNPJAlfaNumerico;

var
  DVs: string;
begin
  DVs := CalculateCNPJCheckDigits('AB1234CD5678');  // retorna '95'
  WriteLn('DVs: ', DVs);
end.
```

## 🔧 Configuração e uso

* **IsValidCNPJ**: retorna `True` apenas se o CNPJ (sem ou com máscara) cumprir todos os requisitos de formato e dígito verificador.
* **CalculateCNPJCheckDigits**: recebe a raiz de 12 caracteres (alfanumérica) e retorna os 2 dígitos verificadores.

## 💡 Observações

* Letras permitidas na raiz: `A`–`Z`, exceto `F`, `I`, `O`, `Q`, `U`.
* A máscara (`.`, `/`, `-`) é automaticamente removida antes da validação.

## ⚠️ License

LazCNPJAlfaNumerico é software livre criado com base nos exemplos disponibilizados na DFe NTCJ 2025.001_CNPJ Alfa_v1.00.pdf com auxílio do ChatGPT, sendo licenciado sob a [MIT License](https://github.com/andre-djsystem/LazCNPJAlfaNumerico/blob/main/LICENSE).
