unit UfrmVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasic, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.DBCtrls, AdvGroupBox, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, RzPanel, AdvGlowButton,
  AdvCombo, Vcl.Imaging.pngimage;

type
  TFrmVenda = class(TFrmBasic)
    PnCaption: TPanel;
    Image1: TImage;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    FDQryItemComanda: TFDQuery;
    FDQryItemComandaCODIGO: TFDAutoIncField;
    FDQryItemComandaCOMANDA: TIntegerField;
    FDQryItemComandaPRODUTO: TIntegerField;
    FDQryItemComandaDESCRICAO: TStringField;
    FDQryItemComandaVALOR: TBCDField;
    FDQryItemComandaQUANTIDADE: TBCDField;
    FDQryItemComandaDESCONTO: TBCDField;
    FDQryItemComandaVALOR_TOTAL_LIQUIDO: TBCDField;
    DsItemComanda: TDataSource;
    FDQryComanda: TFDQuery;
    FDQryComandaCODIGO: TFDAutoIncField;
    FDQryComandaDATA_HORA: TSQLTimeStampField;
    DsComanda: TDataSource;
    RzPanel5: TRzPanel;
    Panel1: TPanel;
    GridItens: TDBGrid;
    FDQryComandaNOME: TStringField;
    FDQryComandaDESCRICAO: TStringField;
    FDQryItemComandaTOT_DESCONTO: TAggregateField;
    FDQryItemComandaTOT_PEDIDO: TAggregateField;
    FDQryItemComandaTOT_PRODUTO: TAggregateField;
    BtnConfirmar: TAdvGlowButton;
    Shape1: TShape;
    DBText7: TDBText;
    Label8: TLabel;
    Shape3: TShape;
    DBText4: TDBText;
    Label5: TLabel;
    Shape4: TShape;
    Label6: TLabel;
    DBText5: TDBText;
    Shape5: TShape;
    Label7: TLabel;
    DBText6: TDBText;
    Shape6: TShape;
    Label2: TLabel;
    DBText1: TDBText;
    Shape7: TShape;
    Label3: TLabel;
    DBText2: TDBText;
    Shape8: TShape;
    DBText3: TDBText;
    Label4: TLabel;
    FDQryComandaGARCOM: TIntegerField;
    FDQryComandaMESA: TIntegerField;
    BtnNovo: TAdvGlowButton;
    BtnAlterar: TAdvGlowButton;
    Shape10: TShape;
    Label9: TLabel;
    DBText8: TDBText;
    FDQryComandaSTATUS: TStringField;
    GroupBox1: TGroupBox;
    BoxAbertas: TCheckBox;
    BoxFechadas: TCheckBox;
    BoxCanceladas: TCheckBox;
    Shape11: TShape;
    Shape9: TShape;
    GroupBox2: TGroupBox;
    EdtPesquisa: TEdit;
    Shape2: TShape;
    Shape12: TShape;
    BtnCancelar: TAdvGlowButton;
    procedure BtnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAlterarClick(Sender: TObject);
    procedure GridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BoxCanceladasClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BtnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    procedure GeraQuery;
    procedure Critica;
  public
    { Public declarations }
  end;

var
  FrmVenda: TFrmVenda;

implementation

{$R *.dfm}

uses UDmBD, UfrmCadVenda, UBiblioteca, UDmLookup, UfrmConfVenda;

procedure TFrmVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDQryComanda.close;
  FDQryItemComanda.close;
  inherited;
end;

procedure TFrmVenda.FormCreate(Sender: TObject);
begin
  inherited;
  GeraQuery;
  FDQryItemComanda.open;
end;

procedure TFrmVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_F3 : BtnAlterarClick(Self);
    VK_F4 : BtnNovoClick(Self);
    VK_F5 : BtnConfirmarClick(Self);
    VK_F6 : BtnCancelarClick(Self);
  end;
end;

procedure TFrmVenda.GeraQuery;
begin
  try
    with FDQryComanda do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select c.CODIGO, c.DATA_HORA, C.GARCOM, g.NOME, '+
                'c.MESA, m.DESCRICAO, c.STATUS '+
                'From COMANDAS c '+
                'Inner Join GARCONS g On c.GARCOM = g.CODIGO '+
                'Inner Join MESAS m On c.MESA = m.CODIGO '+
                'Where 1=1');

        if BoxAbertas.Checked then
          if BoxCanceladas.Checked and BoxFechadas.Checked then
            SQL.Add(' And (c.STATUS = ''A'' Or c.STATUS = ''C'' Or c.STATUS = ''F'') ')
          else if BoxCanceladas.Checked then
            SQL.Add(' And (c.STATUS = ''A'' Or c.STATUS = ''C'') ')
          else if BoxFechadas.Checked then
            SQL.Add(' And (c.STATUS = ''A'' Or c.STATUS = ''F'') ')
          else
            SQL.Add(' And c.STATUS = ''A'' ')
        else if BoxCanceladas.Checked then
          if BoxFechadas.Checked then
            SQL.Add(' And (c.STATUS = ''C'' Or c.STATUS = ''F'') ')
          else
            SQL.Add(' And c.STATUS = ''C'' ')
        else if BoxFechadas.Checked then
          SQL.Add(' And c.STATUS = ''F'' ');

        if trim(EdtPesquisa.Text) <> '' then
          SQL.Add(' And c.CODIGO = '+EdtPesquisa.Text);

        Open();
      end;
  except
    Erro('Não foi possível gerar o arquivo de dados.')
  end;

end;

procedure TFrmVenda.GridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if not odd(FDQryItemComanda.RecNo) then
    if not (gdSelected in State) then
      begin
        GridItens.Canvas.Brush.Color := clMoneyGreen;
        GridItens.Canvas.FillRect(Rect);
        GridItens.DefaultDrawDataCell(rect,Column.Field,state);
      end;
end;

procedure TFrmVenda.BoxCanceladasClick(Sender: TObject);
begin
  GeraQuery;
end;

procedure TFrmVenda.BtnAlterarClick(Sender: TObject);
begin
  inherited;
  Critica;
  try
    FrmCadVenda := TFrmCadVenda.Create(Self);
    FrmCadVenda.FDQryComanda.Edit;
    FrmCadVenda.PCodigo := FDQryComanda.FieldByName('CODIGO').AsInteger;
    FrmCadVenda.ShowModal;
  finally
    FreeAndNil(FrmCadVenda);
    FDQryItemComanda.Refresh;
    FDQryComanda.Refresh;
  end;

end;

procedure TFrmVenda.BtnCancelarClick(Sender: TObject);
begin
  Critica;
  if not pergunta('Confirma o cancelamento da venda?') then
    Abort;
  FDQryComanda.Edit;
  FDQryComanda.FieldByName('STATUS').AsString := 'C';
  FDQryComanda.Post;
  FDQryComanda.Refresh;
end;

procedure TFrmVenda.BtnConfirmarClick(Sender: TObject);
begin
  inherited;
  Critica;
  try
    FrmConfVenda := TFrmConfVenda.Create(Self);
    FrmConfVenda.PCodVenda := FDQryComanda.FieldByName('CODIGO').AsInteger;
    FrmConfVenda.PVlrVenda := FDQryItemComanda.AggFields.FieldByName('TOT_PEDIDO').Value;
    FrmConfVenda.ShowModal;
  finally
    FreeAndNil(FrmConfVenda);
    FDQryComanda.Refresh;
  end;
end;

procedure TFrmVenda.BtnNovoClick(Sender: TObject);
begin
  inherited;
  try
    FrmCadVenda := TFrmCadVenda.Create(Self);
    FrmCadVenda.FDQryComanda.Insert;
    FrmCadVenda.ShowModal;
  finally
    FreeAndNil(FrmCadVenda);
    FDQryComanda.Refresh;
    FDQryComanda.Last;
  end;
end;

procedure TFrmVenda.Critica;
begin
  if FDQryComanda.RecordCount = 0 then
    begin
      Informar('Nenhuma Venda Selecionada!');
      Abort;
    end;
  if FDQryComanda.FieldByName('STATUS').AsString = 'C' then
    begin
      Informar('Venda Cancelada!');
      Abort;
    end;
  if FDQryComanda.FieldByName('STATUS').AsString = 'F' then
    begin
      Informar('Venda Fechada!');
      Abort;
    end;
end;

procedure TFrmVenda.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (Sender as TDBGrid).DataSource.DataSet.FieldByName('STATUS').Value = 'A' then
    (Sender as TDBGrid).Canvas.Font.Color := clBlack
  else if (Sender as TDBGrid).DataSource.DataSet.FieldByName('STATUS').Value = 'C' then
    (Sender as TDBGrid).Canvas.Font.Color := clRed
  else if (Sender as TDBGrid).DataSource.DataSet.FieldByName('STATUS').Value = 'F' then
    (Sender as TDBGrid).Canvas.Font.Color := clGreen;

  DBGrid1.Canvas.FillRect(Rect);
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
