unit UConfigBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  UBiblioteca, Vcl.Imaging.pngimage;

type
  TFrmConfigBanco = class(TForm)
    Image1: TImage;
    EditServidor: TEdit;
    BtnConfigura: TBitBtn;
    EditBanco: TEdit;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConfiguraClick(Sender: TObject);
  private
    procedure Configurar;
    procedure SalvarIni;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfigBanco: TFrmConfigBanco;

implementation

{$R *.dfm}

uses UDmBD;

{ TFConfigBanco }

procedure TFrmConfigBanco.BtnConfiguraClick(Sender: TObject);
begin
  Configurar;
end;

procedure TFrmConfigBanco.Configurar;
begin
  try
  with DmBD do
    begin
      DBConexao.Connected := False;
      DBConexao.Params.Values['Server'] := trim(EditServidor.Text);
      DBConexao.Params.Database := trim(EditBanco.Text);
      DBConexao.Params.UserName := trim(EditUsuario.Text);
      DBConexao.Params.Password := trim(EditSenha.Text);
      DBConexao.Connected := True;
      ShowMessage('Configurado com sucesso!');
      //Salva as configurações no ini
      SalvarIni;
      Self.Close;
    end;
  except
    ShowMessage('Não foi possivel configurar ao Banco');
  end;
end;

procedure TFrmConfigBanco.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DmBD.Free;
  Application.Terminate;
end;

procedure TFrmConfigBanco.SalvarIni;
var
  vFileName: string;
begin
  vFileName := ExtractFilePath(Application.ExeName) + 'Config.ini';
  SetValorIni(vFileName, 'DATABASE','Server', EditServidor.Text);
  SetValorIni(vFileName, 'DATABASE','Database', EditBanco.Text);
  SetValorIni(vFileName, 'DATABASE','UserName', EditUsuario.Text);
  SetValorIni(vFileName, 'DATABASE','Password',EncryptSTR(EditSenha.Text, StKey, MtKey, AdKey));
end;

end.
