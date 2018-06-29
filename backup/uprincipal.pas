unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmGeraCadeias }

  TfrmGeraCadeias = class(TForm)
    btnAdd: TButton;
    btnGerar: TButton;
    btnClear: TButton;
    edtCountRandomChar: TEdit;
    edtCaracter: TEdit;
    edtCaminho: TEdit;
    edtCountCadeias: TEdit;
    edtMaxRepeat: TEdit;
    edtMaxLength: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbl20: TLabel;
    MemoAlfabeto: TMemo;
    procedure btnAddClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    const
      NOME_ARQ = 'TesteCadeias.txt';
    procedure GeraCadeias;
    procedure ValidaQuantidade(Sender: TObject);
    function RandomizeString: string;
  public

  end;

var
  frmGeraCadeias: TfrmGeraCadeias;

implementation

{$R *.lfm}

{ TfrmGeraCadeias }

procedure TfrmGeraCadeias.btnAddClick(Sender: TObject);
var
   lChar: string;
begin
  lChar := Trim(edtCaracter.Text);
  if (lChar <> EmptyStr) and
     (MemoAlfabeto.Lines.IndexOf(lChar) <= -1) then
  begin
    MemoAlfabeto.Lines.Add(lChar);
    edtCaracter.Clear;
  end;
end;

procedure TfrmGeraCadeias.btnGerarClick(Sender: TObject);
begin
  ValidaQuantidade(edtCountCadeias);
  ValidaQuantidade(edtMaxLength);
  ValidaQuantidade(edtMaxRepeat);
  ValidaQuantidade(edtCountRandomChar);
  GeraCadeias;
end;

procedure TfrmGeraCadeias.btnClearClick(Sender: TObject);
begin
  MemoAlfabeto.Clear;
end;

procedure TfrmGeraCadeias.FormCreate(Sender: TObject);
begin
  edtCaminho.Text := ExtractFilePath(Application.ExeName) + NOME_ARQ;
end;

procedure TfrmGeraCadeias.GeraCadeias;
var
  lPath: string;
  lArq: TStringList;
  lCountStrings: Integer;
begin
   lPath := edtCaminho.Text;
   if not ForceDirectories(ExtractFilePath(lPath)) then
   begin
     ShowMessage('Caminho inválido');
     if edtCaminho.CanFocus then
     begin
       edtCaminho.SetFocus;
       Abort;
     end;
   end;
   lArq := TStringList.Create;
   try
      for lCountStrings := 0 to StrtoIntDef(edtCountCadeias.Text, 0) do
      begin
        lArq.Add(RandomizeString);
      end;
      lArq.SaveToFile(lPath);
      if FileExists(lPath) then
      begin
        ShowMessage('Arquivo criado com sucesso!');
      end;
   finally
     lArq.Free;
   end;
end;

procedure TfrmGeraCadeias.ValidaQuantidade(Sender: TObject);
var
   lTexto: string;
   lInt: Integer;
begin
  if Sender is TEdit then
  begin
    lTexto := TEdit(Sender).Text;
    if (not TryStrToInt(lTexto, lInt)) or
       (lInt < 1)then
    begin
      ShowMessage('Informe uma quantidade válida!');
      if TEdit(Sender).CanFocus then
      begin
        TEdit(Sender).SetFocus;
      end;
      Abort;
    end;
  end;
end;

function TfrmGeraCadeias.RandomizeString: string;
var
  lMaxRepeat, lMaxLength: integer;
  lPosChar: integer;
  lChar: string;
  lCountRepeat, lCountRandomChar: integer;
  lIndex, lIndexF: integer;
begin
  Result := EmptyStr;
  lCountRandomChar := StrToIntDef(edtCountRandomChar.Text, 0);
  lMaxRepeat := StrToIntDef(edtMaxRepeat.Text, 0);
  lMaxLength := StrToIntDef(edtMaxLength.Text, 0);

  for lIndexF := 0 to Pred(lCountRandomChar) do
  begin
    //Adicionar aleatoriedade
    if Random(15) = 1 then
    begin
      Break;
    end;

    //Randomizar qual elemento será usado para adicionar à cadeia
    lPosChar := Random(MemoAlfabeto.Lines.Count);
    if lPosChar >= 0 then
    begin
      lChar := MemoAlfabeto.Lines[lPosChar];

      //Randomizar um número de repetição para o mesmo elemento
      lCountRepeat := Random(lMaxRepeat);
      if lCountRepeat >= 1 then
      begin
        for lIndex := 0 to Pred(lCountRepeat) do
        begin
          if Length(Result) >= lMaxLength then
          begin
            Break;
          end;
          Result := Result + lChar;
        end;
      end;
    end;
  end;
end;

end.

