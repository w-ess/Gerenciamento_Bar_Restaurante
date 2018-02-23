unit UBiblioteca;

interface
  uses Winapi.Windows, IniFiles, System.SysUtils, Vcl.Forms, FireDAC.Comp.Client,
  System.Classes, frxClass;

  procedure SetValorIni(pLocal, pSessao, pSubsessao : string ; pValor: string);
  function GetValorIni(pLocal, pSessao, pSubsessao : string): string;
  procedure AtualizaFDQuery(const pFDQuery: TFDQuery; pSQL: string); // Atualizar Query
  procedure ShowModalForm(pClass : TComponentClass; pForm : TForm); //procedure para abre os forms ShowModal
  procedure ShowForm(pClass : TComponentClass; pForm : TForm); //procedure para abre os forms Show
  procedure CarregaRelatorio(const pReport : TfrxReport);  // procedure pra carregar os relatorios
  function EncryptSTR(Const InString:String; StartKey,MultKey,AddKey:Integer): String;  //Função pra criptografar
  function DecryptSTR(Const InString: String; StartKey, MultKey, AddKey: Integer): String;// Função pra descriptografar
  function Aviso(Mensagem: String): String;
  function Erro(Mensagem: String): String;
  function pergunta(Mensagem: String): Boolean;
  function Mensagem(Mensagem: String): String;
  function Atencao(Mensagem: String): String;
  function Informar(Mensagem: String): String;
  function Ok_Cancela(Mensagem, Aviso: String): Boolean;

Const
  // Chaves de encriptação
  StKey = 7848567;
  MtKey = 1741378;
  AdKey = 6574985;

implementation

procedure SetValorIni(pLocal, pSessao, pSubSessao : string ; pValor: string);
var
vArquivo : TiniFile;
begin
  vArquivo := TIniFile.Create(pLocal);
  vArquivo.WriteString(pSessao, pSubsessao, pValor);
  vArquivo.Free;
end;

function GetValorIni(pLocal, pSessao, pSubsessao : string): string;
var
vArquivo : TIniFile;
begin
  vArquivo := TIniFile.Create(pLocal);
  Result := vArquivo.ReadString(pSessao, pSubsessao, '');
end;

procedure AtualizaFDQuery(const pFDQuery: TFDQuery; pSQL: string);
begin
  pFDQuery.Close;
  if Trim(pSQL) <> '' then
  begin
    pFDQuery.SQL.Clear;
    pFDQuery.SQL.Text := pSQL;
  end;
  pFDQuery.Open();
  pFDQuery.FetchAll;
end;

procedure ShowModalForm(pClass : TComponentClass; pForm : TForm);
begin
  try
    Application.CreateForm(pClass, pForm);
    pForm.ShowModal;
  finally
    FreeAndNil(pForm);
  end;
end;

procedure ShowForm(pClass : TComponentClass; pForm : TForm);
begin
  try
    Application.CreateForm(pClass, pForm);
    pForm.Show;
  finally
  // não precisa da o FreeAndNil pq esta fazendo isso no evento onclose do filtroPai
  end;
end;

procedure CarregaRelatorio(const pReport : TfrxReport);
begin
  pReport.PrepareReport;
  pReport.ShowPreparedReport;
end;
{-------------------------------------------------------------------------------}
// PARA ENCRIPTAR
{$R-} {$Q-}
function EncryptSTR(Const InString:String; StartKey,MultKey,AddKey:Integer): String;
var I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
    begin
      Result := Result + Char(Byte(InString[I]) xor (StartKey shr 8));
      StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
    end;
end;
// PARA DESENCRIPTAR
function DecryptSTR(Const InString: String; StartKey, MultKey, AddKey: Integer): String;
var I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
    begin
      Result := Result + Char(Byte(InString[I]) xor (StartKey shr 8));
      StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
    end;
end;
{$R+} {$Q+}
{------------------------------------------------------------------------------}
{ mensagem utilizado "Application.MessageBox" }
function Aviso(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Informação', mb_ok + MB_ICONINFORMATION);
end;

{ mensagem utilizado "Application.MessageBox" sobre erros }
function Erro(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Erro do usuário', mb_ok + MB_ICONERROR);
end;

// rotina para pergunta
function pergunta(Mensagem: String): Boolean;
begin
  if (Application.MessageBox(PChar(Mensagem), 'Atenção', mb_YesNo + mb_iconQuestion)
     = IDYES) then
      Result := true
  else
      Result := false;
end;

function Mensagem(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Mensagem', MB_ICONEXCLAMATION);
end;

function Atencao(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Atenção', MB_ICONWARNING);
end;

function Informar(Mensagem: String): String;
begin
  Application.MessageBox(PChar(Mensagem), 'Informação', MB_ICONINFORMATION);
end;

{ mensagem utilizado "Application.MessageBox" }
function Ok_Cancela(Mensagem, Aviso: String): Boolean;
begin
  if (Application.MessageBox(PChar(Mensagem), PChar(Aviso),
    MB_OKCANCEL + MB_DEFBUTTON1 + mb_iconQuestion) = IDOK) then
     Result := true
  else
     Result := false;
end;

end.
