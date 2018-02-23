unit UfrmVisMesa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasic, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCGrids, Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Shader, AdvGlowButton,
  Vcl.Grids, Vcl.DBGrids, AdvCardList, CurvyControls, RzLine;

type
  TFrmVisMesa = class(TFrmBasic)
    PnCaption: TPanel;
    Image1: TImage;
    Mesas: TLabel;
    DBCtrlGrid1: TDBCtrlGrid;
    Panel1: TPanel;
    Image2: TImage;
    DataSource: TDataSource;
    FDQryMesasDESCRICAO: TStringField;
    dbtxtMesa: TDBText;
    FDQryMesasSTATUS_MESA: TStringField;
    dbtxtStatus: TDBText;
    FDQryMesas: TFDQuery;
    Panel2: TPanel;
    BtnAtualiza: TAdvGlowButton;
    FDQryCom: TFDQuery;
    dsInfCom: TDataSource;
    FDQryComDATA_HORA: TSQLTimeStampField;
    FDQryComVALOR: TBCDField;
    FDQryComMESA: TStringField;
    FDQryComGARCOM: TStringField;
    CurvyPanel1: TCurvyPanel;
    Shape8: TShape;
    Label4: TLabel;
    DBText3: TDBText;
    Label1: TLabel;
    DBText1: TDBText;
    RzLine1: TRzLine;
    Label2: TLabel;
    DBText2: TDBText;
    RzLine2: TRzLine;
    Label3: TLabel;
    DBText4: TDBText;
    RzLine3: TRzLine;
    FDQryMesasCODIGO: TIntegerField;
    FDQryMesasCOMANDA: TIntegerField;
    procedure DBCtrlGrid1PaintPanel(DBCtrlGrid: TDBCtrlGrid; Index: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAtualizaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmVisMesa: TFrmVisMesa;

implementation

{$R *.dfm}

uses UDmBD;

procedure TFrmVisMesa.BtnAtualizaClick(Sender: TObject);
begin
  inherited;
  FDQryMesas.Refresh;
  ShowMessage('atualizado!');
end;

procedure TFrmVisMesa.DBCtrlGrid1PaintPanel(DBCtrlGrid: TDBCtrlGrid;
  Index: Integer);
begin
  //inherited;
  if FDQryMesas.Active = true then
    if FDQryMesas.FieldByName('STATUS_MESA').AsString = 'LIVRE' then
      begin
        dbtxtStatus.Font.Color := clGreen
      end
    else
      begin
        dbtxtStatus.Font.Color := clRed;
      end;
end;

procedure TFrmVisMesa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FDQryMesas.Close;
  FDQryCom.Close;
end;

procedure TFrmVisMesa.FormCreate(Sender: TObject);
begin
  inherited;
  FDQryMesas.Open;
  FDQryCom.Open;
end;

procedure TFrmVisMesa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_F5 then
    BtnAtualizaClick(Self);
end;

end.
