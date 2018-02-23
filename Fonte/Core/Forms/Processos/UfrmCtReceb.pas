unit UfrmCtReceb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasicCrudMasterDetail, Data.DB,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  Vcl.Mask, Vcl.DBCtrls;

type
  TFrmCadCtReceb = class(TFrmBasicCrudMasterDetail)
    FDQryPai: TFDQuery;
    FDSchemaAdapter1: TFDSchemaAdapter;
    FDQryFilho: TFDQuery;
    FDQuery: TFDQuery;
    DsFilho: TDataSource;
    FDQryPaiCODIGO: TFDAutoIncField;
    FDQryPaiEMPRESA: TIntegerField;
    FDQryPaiDATA_CADASTRO: TDateField;
    FDQryPaiDATA: TDateField;
    FDQryPaiPAGADOR: TIntegerField;
    FDQryPaiOBSERVACAO: TStringField;
    FDQryFilhoCODIGO: TFDAutoIncField;
    FDQryFilhoCONTA_RECEBER: TIntegerField;
    FDQryFilhoTITULO: TStringField;
    FDQryFilhoPARCELA: TIntegerField;
    FDQryFilhoVALOR: TBCDField;
    FDQryFilhoJUROS: TBCDField;
    FDQryFilhoMULTA: TBCDField;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    Label8: TLabel;
    DBEdit6: TDBEdit;
    GBoxTitulos: TGroupBox;
    Button1: TButton;
    DBGrid1: TDBGrid;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EdtTitulo: TEdit;
    edtParcela: TEdit;
    edtValor: TEdit;
    edtJuros: TEdit;
    edtMulta: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
    procedure TabCrudShow(Sender: TObject);
    procedure TabQueryShow(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimparCache(Sender: TObject);
    procedure CarregaEdit(Sender: TOBject);
    procedure LimparEdit;
  public
    { Public declarations }
  end;

var
  FrmCadCtReceb: TFrmCadCtReceb;

implementation

{$R *.dfm}

procedure TFrmCadCtReceb.ActCancelarExecute(Sender: TObject);
begin
  inherited;
  FDSchemaAdapter1.CancelUpdates;
  PageControl.ActivePage := TabQuery;
end;

procedure TFrmCadCtReceb.ActSalvarExecute(Sender: TObject);
begin
  inherited;
  FDSchemaAdapter1.ApplyUpdates(0);
  FDQuery.Refresh;
  PageControl.ActivePage := TabQuery;
end;

procedure TFrmCadCtReceb.Button1Click(Sender: TObject);
begin
  inherited;
  if FDQryPai.State in [dsInsert] then
    FDQryPai.Post;

  if not (FDQryFilho.State in [dsEdit]) then
     FDQryFilho.Insert;

  FDQryFilho.FieldByName('TITULO').AsString  := EdtTitulo.Text;
  FDQryFilho.FieldByName('PARCELA').AsString := edtParcela.Text;
  FDQryFilho.FieldByName('VALOR').AsString   := edtValor.Text;
  FDQryFilho.FieldByName('JUROS').AsString   := edtJuros.Text;
  FDQryFilho.FieldByName('MULTA').AsString   := edtMulta.Text;
  FDQryFilho.Post;
  LimparEdit;
end;

procedure TFrmCadCtReceb.CarregaEdit(Sender: TOBject);
begin
  EdtTitulo.Text  := DsFilho.DataSet.fieldbyname('TITULO').Asstring;
  EdtParcela.Text := DsFilho.DataSet.fieldbyname('PARCELA').Asstring;
  EdtValor.Text   := DsFilho.DataSet.fieldbyname('VALOR').AsString;
  EdtJuros.Text   := DsFilho.DataSet.fieldbyname('JUROS').AsString;
  EdtMulta.Text   := DsFilho.DataSet.fieldbyname('MULTA').AsString;
  FDQryFilho.Edit;
end;

procedure TFrmCadCtReceb.DBGrid1DblClick(Sender: TObject);
begin
 CarregaEdit(Sender);
 // EdtTitulo.Text := DsFilho.DataSet.fieldbyname('TITULO').asstring;
 // EdtParcela.Text := DsFilho.DataSet.fieldbyname('PARCELA').asstring;
end;

procedure TFrmCadCtReceb.LimparCache(Sender: TObject);
begin
  FDQryPai.CommitUpdates();
  FDQryFilho.CommitUpdates();
end;

procedure TFrmCadCtReceb.LimparEdit;
begin
  EdtTitulo.Text  := '';
  EdtParcela.Text := '';
  EdtValor.Text   := '';
  EdtJuros.Text   := '';
  EdtMulta.Text   := '';
  EdtTitulo.SetFocus;
end;

procedure TFrmCadCtReceb.TabCrudShow(Sender: TObject);
begin
  inherited;
  if not FDQryFilho.Active then
    FDQryFilho.Open;
  FDSchemaAdapter1.AfterApplyUpdate := LimparCache;
end;

procedure TFrmCadCtReceb.TabQueryShow(Sender: TObject);
begin
  inherited;
  DBEdit1.Color := clWindow;;
  DBEdit1.Font.Color := clWindowText;
end;

end.
