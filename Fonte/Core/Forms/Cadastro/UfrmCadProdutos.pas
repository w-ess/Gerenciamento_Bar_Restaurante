unit UfrmCadProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasicCrud, Data.DB,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Mask, Vcl.DBCtrls;

type
  TFrmCadProduto = class(TFrmBasicCrud)
    FDQuery: TFDQuery;
    FDQryCad: TFDQuery;
    FDQueryCODIGO: TFDAutoIncField;
    FDQueryDESCRICAO: TStringField;
    FDQueryPRECO: TBCDField;
    FDQryCadCODIGO: TFDAutoIncField;
    FDQryCadDESCRICAO: TStringField;
    FDQryCadPRECO: TBCDField;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    procedure ActIncluirExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCadProduto: TFrmCadProduto;

implementation

{$R *.dfm}

uses UDmBD;

procedure TFrmCadProduto.ActIncluirExecute(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := clBtnFace;
  DBEdit1.Font.Color := clBtnFace;
  DBEdit2.SetFocus;
end;

end.
