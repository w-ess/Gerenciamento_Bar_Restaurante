unit UfrmConfVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls,
  Vcl.StdCtrls, AdvCombo, AdvEdit, Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TFrmConfVenda = class(TForm)
    PnCaption: TPanel;
    Image1: TImage;
    LblCaption: TLabel;
    ComboForPag: TAdvComboBox;
    Shape1: TShape;
    Label2: TLabel;
    Shape2: TShape;
    Label4: TLabel;
    Shape3: TShape;
    Label5: TLabel;
    Shape4: TShape;
    Label6: TLabel;
    FDQryPsq: TFDQuery;
    EdtVlrReceb: TAdvEdit;
    EdtTroco: TAdvEdit;
    EdtVlrVenda: TAdvEdit;
    BtnConfirmar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure EdtVlrRecebChange(Sender: TObject);
  private
    { Private declarations }
    procedure GeraComboForPag;
    procedure Critica;
  public
    { Public declarations }
    PCodVenda : Integer;
    PVlrVenda : Double;
  end;

var
  FrmConfVenda: TFrmConfVenda;
  VetForPag : Variant;

implementation

{$R *.dfm}

uses UDmBD, UBiblioteca, UfrmCupomVenda;

{ TForm1 }

procedure TFrmConfVenda.BtnConfirmarClick(Sender: TObject);
begin
  Critica;
  //A = Aberta //C = Cancelada // F = Fechada
  try
    with FDQryPsq do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update COMANDAS Set STATUS = ''F'', ' +
                'FORMA_PAGAMENTO = '+IntToStr(ComboForPag.ItemIndex+1) +
                ' Where CODIGO = '+IntToStr(PCodVenda));

        ExecSQL;
      end;
  except
    begin
      Erro('Erro ao mudar o status da venda.');
      Abort;
    end;
  end;

  if pergunta('Deseja imprimir o CUPOM?') then
    begin
      //cchamar impressãp do boleto
      try
        FrmCupomVenda := TFrmCupomVenda.Create(Self);
        FrmCupomVenda.PCodigo := PCodVenda;
        FrmCupomVenda.QrCupom.Print;
      finally
        FreeAndNil(FrmCupomVenda);
      end;
    end;

  Close;

end;

procedure TFrmConfVenda.Critica;
Var VlrRecebido : Double;
begin
  VlrRecebido := StrToFloatDef(StringReplace(EdtVlrReceb.Text, '.', '', [rfReplaceAll]),0);

  if ComboForPag.ItemIndex < 0 then
    begin
      Atencao('Forma de pagamento inválida!...');
      ComboForPag.SetFocus;
      Abort;
    end;
  if VlrRecebido < PVlrVenda then
    begin
      Atencao('Valor inferior ao valor da venda!...');
      EdtVlrReceb.SetFocus;
      Abort;
    end;
end;

procedure TFrmConfVenda.EdtVlrRecebChange(Sender: TObject);
begin
  EdtTroco.Value := (EdtVlrReceb.Value - EdtVlrVenda.Value);
end;

procedure TFrmConfVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmConfVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close; // se pressionar esc o form é fechado
    VK_RETURN: Perform(WM_NEXTDLGCTL,0,0); //pressionar enter muda o foco para o proximo controle  .
    VK_F7 : BtnConfirmarClick(Self);
  end;
end;

procedure TFrmConfVenda.FormShow(Sender: TObject);
begin
  LblCaption.Caption := 'Finalizar Venda '+IntToStr(PCodVenda);
  EdtVlrVenda.Value  := PVlrVenda;
  GeraComboForPag;
end;

procedure TFrmConfVenda.GeraComboForPag;
var
  I   : integer;
begin
  FDQryPsq.Close;
  FDQryPsq.SQL.Clear;
  FDQryPsq.SQL.Add('Select CODIGO, DESCRICAO From FORMAS_PAGAMENTOS');
  FDQryPsq.Open;

  VetForPag := VarArrayCreate([0,FDQryPsq.RecordCount-1],varInteger);
  ComboForPag.Items.Clear;

  I := 0;
  while not FDQryPsq.EOF do
    begin
      ComboForPag.Items.Add(trim(FDQryPsq.FieldByName('DESCRICAO').AsString));
      VetForPag[I] := FDQryPsq.FieldByName('CODIGO').AsInteger;
      Inc(I);
      FDQryPsq.Next;
    end;
  FDQryPsq.Close;
  ComboForPag.ItemIndex := -1;
end;

end.
