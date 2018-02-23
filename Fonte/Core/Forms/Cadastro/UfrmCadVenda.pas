unit UfrmCadVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasic, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, AdvGroupBox, Vcl.Mask,
  Vcl.DBCtrls, AdvEdit, Vcl.Buttons, AdvGlowButton, RzPanel, RzDBCmbo, AdvCombo,
  Vcl.Imaging.pngimage ;

type
  TFrmCadVenda = class(TFrmBasic)
    PnCaption: TPanel;
    Image1: TImage;
    Label1: TLabel;
    FDQryComanda: TFDQuery;
    FDQryItemComanda: TFDQuery;
    FDQryComandaCODIGO: TFDAutoIncField;
    FDQryComandaDATA_HORA: TSQLTimeStampField;
    FDQryComandaGARCOM: TIntegerField;
    FDQryComandaMESA: TIntegerField;
    DsComanda: TDataSource;
    DsItemComanda: TDataSource;
    Panel1: TPanel;
    BtnConfirmar: TAdvGlowButton;
    FDSchemaAdapter: TFDSchemaAdapter;
    FDQryPsq: TFDQuery;
    FDQryItemComandaCODIGO: TFDAutoIncField;
    FDQryItemComandaCOMANDA: TIntegerField;
    FDQryItemComandaPRODUTO: TIntegerField;
    FDQryItemComandaDESCRICAO: TStringField;
    FDQryItemComandaVALOR: TBCDField;
    FDQryItemComandaQUANTIDADE: TBCDField;
    FDQryItemComandaDESCONTO: TBCDField;
    LblSubTotal: TLabel;
    FDQryItemComandaSUBTOTAL: TAggregateField;
    DBText1: TDBText;
    FDQryItemComandaVALOR_TOTAL_LIQUIDO: TBCDField;
    RzPanel1: TRzPanel;
    LblVenda: TLabel;
    LblData: TLabel;
    BtnIncluir: TAdvGlowButton;
    RzPanel2: TRzPanel;
    Label11: TLabel;
    LblMesa: TLabel;
    Label3: TLabel;
    RzPanel3: TRzPanel;
    Label9: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label10: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    EdtDesProduto: TEdit;
    EdtQtde: TAdvEdit;
    EdtVlrUnit: TAdvEdit;
    EdtVlrTotal: TAdvEdit;
    EdtCodProduto: TAdvEdit;
    EdtDesconto: TAdvEdit;
    BtnPsqPrd: TAdvGlowButton;
    RzPanel4: TRzPanel;
    GridItens: TDBGrid;
    ComboMesa: TAdvComboBox;
    Shape7: TShape;
    ComboGarcom: TAdvComboBox;
    Shape8: TShape;
    FDQryComandaSTATUS: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnIncluirClick(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure EdtCodProdutoExit(Sender: TObject);
    procedure EdtQtdeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure BtnPsqPrdClick(Sender: TObject);
  private
    { Private declarations }
    procedure GeraComboMesa;
    procedure GeraComboGarcom;
    procedure LimparCache(Sender: TObject);
    procedure GetProduto(PCodigo: String);
    procedure GravarCabe;
    procedure GravarItem;
    procedure LimparEditItem;
    procedure Critica;
  public
    { Public declarations }
    PCodigo : Integer;
  end;

var
  FrmCadVenda: TFrmCadVenda;
  VetMesa    : Variant;
  VetGarcom  : Variant;

implementation

{$R *.dfm}

uses UDmBD, UDmLookup, UBiblioteca, UfrmVenda, UfrmBasicPesquisa;

procedure TFrmCadVenda.BtnIncluirClick(Sender: TObject);
begin
  inherited;
  Critica;

  GravarCabe;

  FDQryItemComanda.Insert;
  GravarItem;

  if not LblSubTotal.Visible then
    LblSubTotal.Visible := True;

  LimparEditItem;

end;

procedure TFrmCadVenda.BtnPsqPrdClick(Sender: TObject);
begin
  inherited;
  try
    FrmBasicPesquisa := TFrmBasicPesquisa.Create(Self);
    FrmBasicPesquisa.Titulo := 'Pesquisa de Produtos';
    FrmBasicPesquisa.Query := 'Select CODIGO, DESCRICAO From PRODUTOS Order By DESCRICAO';
    FrmBasicPesquisa.ShowModal;
  finally
    EdtCodProduto.Value := FrmBasicPesquisa.Codigo;
    EdtCodProdutoExit(Sender);
    EdtQtde.SetFocus;
    FreeAndNil(FrmBasicPesquisa);
  end;
end;

procedure TFrmCadVenda.Critica;
begin
  if ComboMesa.ItemIndex < 0 then
    begin
      Atencao('Mesa inv�lida!');
      ComboMesa.SetFocus;
      Abort;
    end;
  if ComboGarcom.ItemIndex < 0 then
    begin
      Atencao('Gar�om inv�lido!');
      ComboGarcom.SetFocus;
      Abort;
    end;
  if (EdtCodProduto.Text = '0') or (EdtDesProduto.Text = '') then
    begin
      Atencao('C�digo inv�lido!');
      EdtCodProduto.SetFocus;
      Abort;
    end;
  if (EdtQtde.Text = '0') or (EdtQtde.Text = '') then
    begin
      Atencao('Quantidade inv�lida!');
      EdtQtde.SetFocus;
      Abort;
    end;
end;

procedure TFrmCadVenda.BtnConfirmarClick(Sender: TObject);
begin
  inherited;
  LimparEditItem;
  if not pergunta('Confirma a venda?') then
    Abort;

  // -1 tenta gravar todas as atualiza��es pendentes
  // 0 interrompe o processo ao encontrar o primeiro erro
  // 1 permite q (1) erro ocorra ou (n) erros ocorra
  if FDQryItemComanda.RecordCount > 0 then
    begin
      if FDQryComanda.State in [dsEdit] then //Garante a grava��o do cabe�alho
        GravarCabe;
      FDSchemaAdapter.ApplyUpdates(0);
    end
  else
    Atencao('Venda sem itens!');
  Close;
end;

procedure TFrmCadVenda.EdtCodProdutoExit(Sender: TObject);
begin
  inherited;
  if trim(EdtCodProduto.Text) <> '0' then
    GetProduto(EdtCodProduto.Text);
end;

procedure TFrmCadVenda.EdtQtdeExit(Sender: TObject);
begin
  inherited;
  EdtVlrTotal.Value := (EdtQtde.Value * EdtVlrUnit.Value) - EdtDesconto.Value;
end;

procedure TFrmCadVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDQryComanda.Close;
  FDQryItemComanda.Close;
  inherited;
end;

procedure TFrmCadVenda.FormCreate(Sender: TObject);
begin
  inherited;
  FDSchemaAdapter.AfterApplyUpdate := LimparCache;

  FDQryComanda.Open;
  FDQryItemComanda.Open;
end;

procedure TFrmCadVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if key = VK_F4 then
    BtnIncluirClick(self);
  if key = VK_F5 then
    BtnConfirmarClick(self);
end;

procedure TFrmCadVenda.FormShow(Sender: TObject);
begin
  inherited;
  if FDQryComanda.State in [dsInsert] then
    LblSubTotal.Visible := False
  else if FDQryComanda.State in [dsEdit] then
    begin
      FDQryComanda.Close;
      FDQryComanda.SQL.Clear;
      FDQryComanda.SQL.Add('Select * From COMANDAS Where CODIGO = '+IntToStr(PCodigo));
      FDQryComanda.open;
      FDQryComanda.Edit;
      LblVenda.Caption := 'VENDA N� '+FormatFloat('000000', FDQryComanda.FieldByName('CODIGO').AsInteger);
      LblData.Caption  := 'DATA '+FormatDateTime('DD/MM/YYYY', FDQryComanda.FieldByName('DATA_HORA').AsDateTime);
      LblVenda.Visible := True;
      LblData.Visible  := True;
    end;
  GeraComboMesa;
  GeraComboGarcom;
  ComboMesa.SetFocus;
end;

procedure TFrmCadVenda.GeraComboGarcom;
var
  I   : integer;
begin
  FDQryPsq.Close;
  FDQryPsq.SQL.Clear;
  FDQryPsq.SQl.Add('Select CODIGO, NOME From GARCONS');
  FDQryPsq.Open;

  VetGarcom := VarArrayCreate([0,FDQryPsq.RecordCount-1],varInteger);
  ComboGarcom.Items.Clear;

  I := 0;
  while not FDQryPsq.EOF do
    begin
      ComboGarcom.Items.Add(trim(FDQryPsq.FieldByName('NOME').AsString));
      VetGarcom[I] := FDQryPsq.FieldByName('CODIGO').AsInteger;
      Inc(I);
      FDQryPsq.Next;
    end;
  FDQryPsq.Close;
  // preeche o combo se estiver em edi��o
  if FDQryComanda.State in [dsEdit] then
    begin
      for I := 0 to VarArrayHighBound(VetGarcom,1) do
        if VetGarcom[I] = FDQryComanda.FieldByName('GARCOM').AsInteger then
          begin
            ComboGarcom.ItemIndex := I;
            break;
          end;
    end
  else
    ComboGarcom.ItemIndex := -1;
end;

procedure TFrmCadVenda.GeraComboMesa;
var
  I   : integer;
begin
  FDQryPsq.Close;
  FDQryPsq.SQL.Clear;
  FDQryPsq.SQL.Add('Select CODIGO, DESCRICAO From MESAS');
  FDQryPsq.Open;

  VetMesa := VarArrayCreate([0,FDQryPsq.RecordCount-1],varInteger);
  ComboMesa.Items.Clear;

  I := 0;
  while not FDQryPsq.EOF do
    begin
      ComboMesa.Items.Add(trim(FDQryPsq.FieldByName('DESCRICAO').AsString));
      VetMesa[I] := FDQryPsq.FieldByName('CODIGO').AsInteger;
      Inc(I);
      FDQryPsq.Next;
    end;
  FDQryPsq.Close;
  // preeche o combo se estiver em edi��o
  if FDQryComanda.State in [dsEdit] then
    begin
      for I := 0 to VarArrayHighBound(VetMesa,1) do
        if VetMesa[I] = FDQryComanda.FieldByName('MESA').AsInteger then
          begin
            ComboMesa.ItemIndex := I;
            break;
          end;
    end
  else
    ComboMesa.ItemIndex := -1;
end;

procedure TFrmCadVenda.GetProduto(PCodigo: String);
begin
  with FDQryPsq do
    begin
      Close;
      SQL.Clear;
      try
        SQL.Add('Select DESCRICAO, PRECO From PRODUTOS '+
                'Where CODIGO = '+PCodigo);
        Open;
      except
        Erro('N�o foi poss�vel localizar o registro.');
        Abort;
      end;
    end;

  if FDQryPsq.RecordCount > 0 then
    begin
      EdtDesProduto.Text := FDQryPsq.FieldByName('DESCRICAO').AsString;
      EdtVlrUnit.Value := FDQryPsq.FieldByName('PRECO').AsFloat;
    end
  else
    begin
      Atencao('C�digo inv�lido!');
      EdtCodProduto.SetFocus;
      EdtDesProduto.Text := '';
    end;
end;

procedure TFrmCadVenda.GravarCabe;
begin
  if FDQryComanda.State in [dsInsert, dsEdit] then
    begin
      FDQryComanda.FieldByName('MESA').AsInteger := VetMesa[ComboMesa.ItemIndex];
      FDQryComanda.FieldByName('GARCOM').AsInteger := VetGarcom[ComboGarcom.ItemIndex];
      FDQryComanda.FieldByName('STATUS').AsString := 'A';
      FDQryComanda.Post;
    end;
end;

procedure TFrmCadVenda.GravarItem;
begin
  FDQryItemComanda.FieldByName('PRODUTO').AsInteger := EdtCodProduto.Value;
  FDQryItemComanda.FieldByName('DESCRICAO').AsString := EdtDesProduto.Text;
  FDQryItemComanda.FieldByName('QUANTIDADE').AsInteger := EdtQtde.Value;
  FDQryItemComanda.FieldByName('VALOR').AsFloat := EdtVlrUnit.Value;
  FDQryItemComanda.FieldByName('DESCONTO').AsFloat := EdtDesconto.Value;
  FDQryItemComanda.FieldByName('VALOR_TOTAL_LIQUIDO').AsFloat := (FDQryItemComanda.FieldByName('QUANTIDADE').AsInteger *
  FDQryItemComanda.FieldByName('VALOR').AsFloat)-FDQryItemComanda.FieldByName('DESCONTO').AsFloat;
  FDQryItemComanda.Post;
end;

procedure TFrmCadVenda.GridItensDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
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

procedure TFrmCadVenda.LimparCache(Sender: TObject);
begin
  FDQryComanda.CommitUpdates();
  FDQryItemComanda.CommitUpdates();
end;

procedure TFrmCadVenda.LimparEditItem;
begin
  EdtCodProduto.Value := 0;
  EdtDesProduto.Text  := '';
  EdtQtde.Value       := 0;
  EdtVlrUnit.Value    := 0;
  EdtDesconto.Value   := 0;
  EdtVlrTotal.Value   := 0;
  EdtCodProduto.SetFocus;
end;

end.
