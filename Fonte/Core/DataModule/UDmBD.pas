unit UDmBD;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,Vcl.Forms, FireDAC.Phys.ODBCBase, ULogin;

type
  TDmBD = class(TDataModule)
    DBConexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure CarregaBanco;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmBD: TDmBD;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses UPrincipal, UBiblioteca, UConfigBanco;

{$R *.dfm}

{ TDmBD }

procedure TDmBD.CarregaBanco;
begin

  if FileExists(ExtractFilePath(Application.Exename)+ 'Config.ini') then
    begin
      DBConexao.Connected := False;
      DBConexao.Params.Values['Server'] := GetValorIni(ExtractFilePath(Application.Exename)+ 'Config.ini', 'DATABASE', 'Server');
      DBConexao.Params.Database := GetValorIni(ExtractFilePath(Application.Exename)+ 'Config.ini', 'DATABASE', 'Database');
      DBConexao.Params.UserName := GetValorIni(ExtractFilePath(Application.Exename)+ 'Config.ini', 'DATABASE', 'UserName');
      DBConexao.Params.Password := DecryptSTR(GetValorIni(ExtractFilePath(Application.Exename)+ 'Config.ini', 'DATABASE', 'Password'),StKey, MtKey, AdKey);
      DBConexao.Connected := True;
      ShowModalForm(TFrmLogin, FrmLogin);
    end
  else
    begin
      ShowModalForm(TFrmConfigBanco, FrmConfigBanco);
    end;
end;

procedure TDmBD.DataModuleCreate(Sender: TObject);
begin
  CarregaBanco;
end;

end.
