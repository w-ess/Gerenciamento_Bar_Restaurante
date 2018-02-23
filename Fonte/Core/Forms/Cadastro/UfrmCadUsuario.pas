unit UfrmCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasicCrud, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.DBCtrls, Vcl.Mask, Vcl.Imaging.pngimage;

type
  TFrmCadUsuario = class(TFrmBasicCrud)
    FDQuery: TFDQuery;
    FDQueryCODIGO: TFDAutoIncField;
    FDQueryNOME: TStringField;
    FDQueryLOGIN: TStringField;
    FDQueryBLOQUEADO: TBooleanField;
    FDQryCad: TFDQuery;
    FDAutoIncField1: TFDAutoIncField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    BooleanField1: TBooleanField;
    Label2: TLabel;
    EdtCodigo: TDBEdit;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    EdtSenha: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    procedure ActIncluirExecute(Sender: TObject);
    procedure TabQueryShow(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadUsuario: TFrmCadUsuario;

implementation

{$R *.dfm}

uses UDmBD, UBiblioteca;

{ TFrmCadUsuario }
{ TFrmCadUsuario }


procedure TFrmCadUsuario.ActIncluirExecute(Sender: TObject);
begin
  inherited;
  EdtCodigo.Color := clBtnFace;
  EdtCodigo.Font.Color := clBtnFace;
  DBEdit2.SetFocus;
end;

procedure TFrmCadUsuario.ActSalvarExecute(Sender: TObject);
begin
  //salvar senha criptografada
  //FDQryCad.FieldByName('SENHA').AsString := EncryptSTR(EdtSenha.Text, StKey, MtKey, AdKey);
  inherited;
end;

procedure TFrmCadUsuario.TabQueryShow(Sender: TObject);
begin
  inherited;
  EdtCodigo.Color := clWindow;;
  EdtCodigo.Font.Color := clWindowText;
end;

end.
