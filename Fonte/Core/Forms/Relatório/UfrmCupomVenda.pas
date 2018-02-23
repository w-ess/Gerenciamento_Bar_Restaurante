unit UfrmCupomVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, QuickRpt, QRCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFrmCupomVenda = class(TForm)
    QrCupom: TQuickRep;
    QRBand1: TQRBand;
    QRSysData1: TQRSysData;
    FDQryVenda: TFDQuery;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRShape1: TQRShape;
    QRBand2: TQRBand;
    QRDBText1: TQRDBText;
    QRExpr1: TQRExpr;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRBand3: TQRBand;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRExpr2: TQRExpr;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRExpr3: TQRExpr;
    QRExpr4: TQRExpr;
    QRDBText6: TQRDBText;
    QRExpr5: TQRExpr;
    procedure QrCupomBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QrCupomAfterPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PCodigo : Integer;
  end;

var
  FrmCupomVenda: TFrmCupomVenda;

implementation

{$R *.dfm}

uses UDmBD;

procedure TFrmCupomVenda.QrCupomAfterPrint(Sender: TObject);
begin
  FDQryVenda.Close;
end;

procedure TFrmCupomVenda.QrCupomBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  with FDQryVenda do
    begin
      Close;
      ParamByName('PCODIGO').AsInteger := PCodigo;
      Open;
    end;
end;

end.
