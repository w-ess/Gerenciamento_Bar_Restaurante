unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, UBiblioteca, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TFrmLogin = class(TForm)
    GrpBoxLogin: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    EdtLogin: TEdit;
    EdtSenha: TEdit;
    BtnOK: TBitBtn;
    BtnCancelar: TBitBtn;
    QryUsuar: TFDQuery;
    PnCaption: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label4: TLabel;
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses UPrincipal, UDmBD, USplash;

procedure TFrmLogin.BtnCancelarClick(Sender: TObject);
begin
  DmBD.Free;
  Application.Terminate;
end;

procedure TFrmLogin.BtnOKClick(Sender: TObject);
begin
  if Trim(EdtLogin.Text) = '' then
    begin
      Atencao('Voc� esqueceu de informar o seu nome de Login');
      EdtLogin.SetFocus;
      Abort;
    end;

  if Trim(EdtSenha.Text) = '' then
    begin
      Atencao('Voc� esqueceu de informar a sua senha de Login');
      EdtSenha.SetFocus;
      Abort;
    end;

  with QryUsuar do
    begin
      Close;
      ParamByName('Login').AsString := UpperCase(Trim(EdtLogin.Text));
      ParamByName('Senha').AsString := UpperCase(Trim(EdtSenha.Text));
      Open;
      if not IsEmpty then
        begin
          if FieldByName('BLOQUEADO').AsBoolean then
            begin
              Informar('Prezado(a) '+sLineBreak+
              'Voc� est� cadastrado no sistema, por�m seu acesso n�o est� autorizado.'+sLineBreak+
              'Por favor, informe o administrador do sistema.');
              EdtLogin.SetFocus;
              abort;
            end;
        end
      else
        begin
          Atencao('Usu�rio ou Senha n�o foram reconhecido pelo sistema.'
          + #13 + 'Acesso negado');
          EdtLogin.SetFocus;
          abort;
        end;
      Close;
    end;
  Self.Close;
  ShowForm(TFrmPrincipal, FrmPrincipal);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
procedure TFrmLogin.FormCreate(Sender: TObject);
begin
  FSplash.Close;
end;

end.
