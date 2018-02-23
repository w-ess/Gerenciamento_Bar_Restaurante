unit UfrmBasicCrudMasterDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasic, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.DBCtrls,
  FireDAC.Comp.Client;

type
  TRecodState = (rsNew, rsEdit, rsDelete);// Enumerado
  TFrmBasicCrudMasterDetail = class(TFrmBasic)
    PnCaption: TPanel;
    Image1: TImage;
    Label1: TLabel;
    ActionList1: TActionList;
    ActIncluir: TAction;
    ActAlterar: TAction;
    ActExcluir: TAction;
    ActCancelar: TAction;
    ActSalvar: TAction;
    ActSair: TAction;
    ActImprimir: TAction;
    ActVisualizar: TAction;
    ActAnterior: TAction;
    ActProximo: TAction;
    ActPrimeiro: TAction;
    ActUltimo: TAction;
    Img: TImageList;
    ImgAction: TImageList;
    DsQuery: TDataSource;
    DsCrud: TDataSource;
    pnTools: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton11: TSpeedButton;
    StaBarInfo: TStatusBar;
    PageControl: TPageControl;
    TabCrud: TTabSheet;
    pnControl: TPanel;
    TabQuery: TTabSheet;
    Panel1: TPanel;
    EdtPesquisa: TButtonedEdit;
    DbgrQuery: TDBGrid;
    procedure ActIncluirExecute(Sender: TObject);
    procedure ActAlterarExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
    procedure ActSairExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure EdtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure DbgrQueryTitleClick(Column: TColumn);
    procedure EdtPesquisaLeftButtonClick(Sender: TObject);
    procedure EdtPesquisaRightButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TabQueryShow(Sender: TObject);
  private
    { Private declarations }
    //objeto usado na rotina de consulta
    FieldFilter: TField;
    FRecodState : TRecodState; // vai servi pra controlar a intensão do usuário
    procedure ListaCampoObrigatorio;
    procedure ControleBotoes(Habilita : Boolean);
    procedure OpenCrud;
  public
    { Public declarations }
  end;

var
  FrmBasicCrudMasterDetail: TFrmBasicCrudMasterDetail;

implementation

{$R *.dfm}

uses UBiblioteca;

{ TFrmBasicCrudMasterDetail }

procedure TFrmBasicCrudMasterDetail.ActAlterarExecute(Sender: TObject);
begin
  inherited;
  OpenCrud;
  DsCrud.DataSet.Edit;
  PageControl.ActivePage := TabCrud;
  FRecodState := rsEdit;
end;

procedure TFrmBasicCrudMasterDetail.ActAnteriorExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Prior;
end;

procedure TFrmBasicCrudMasterDetail.ActCancelarExecute(Sender: TObject);
begin
  inherited;
  case FRecodState of
    rsNew:
      if not pergunta('Confirma o cancelamento da inclusão do registro?')then
        Abort;
    rsEdit:
      if not pergunta('Confirma o cancelamento da edição do registro?') then
        Abort;
  end;
end;

procedure TFrmBasicCrudMasterDetail.ActExcluirExecute(Sender: TObject);
begin
  inherited;
  if pergunta('Confirma a exclusão do registro?') then
    DsQuery.DataSet.Delete;
end;

procedure TFrmBasicCrudMasterDetail.ActIncluirExecute(Sender: TObject);
begin
  ControleBotoes(False);
  //garante a inclusão do item sem filtro
  DsCrud.DataSet.Close;
  DsCrud.DataSet.Filtered := False;
  DsCrud.DataSet.Filter := '';
  DsCrud.DataSet.Open;

  DsCrud.DataSet.Insert;
  PageControl.ActivePage := TabCrud;
  ListaCampoObrigatorio;
  StaBarInfo.SimpleText := '* Campos em vermelho são obrigatórios!';
  FRecodState := rsNew;
end;

procedure TFrmBasicCrudMasterDetail.ActPrimeiroExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.First;
end;

procedure TFrmBasicCrudMasterDetail.ActProximoExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Next;
end;

procedure TFrmBasicCrudMasterDetail.ActSairExecute(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmBasicCrudMasterDetail.ActSalvarExecute(Sender: TObject);
begin
  inherited;
  case FRecodState of
    rsNew:
      if not pergunta('Confirma a inclusão do registro?') then
        Abort;
    rsEdit:
      if not pergunta('Confirma a edição do registro?') then
        Abort;
  end;
end;

procedure TFrmBasicCrudMasterDetail.ActUltimoExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Last;
end;

procedure TFrmBasicCrudMasterDetail.ControleBotoes(Habilita: Boolean);
begin
  //Habilita true
  if Habilita then
    begin
      ActIncluir.Enabled := True;
      ActAlterar.Enabled := True;
      ActExcluir.Enabled := True;
      ActCancelar.Enabled := False;
      ActSalvar.Enabled := False;
      ActPrimeiro.Enabled := True;
      ActAnterior.Enabled := True;
      ActProximo.Enabled := True;
      ActUltimo.Enabled := True;
      ActSair.Enabled := True;
    end
  else
    begin
      ActIncluir.Enabled := False;
      ActAlterar.Enabled := False;
      ActExcluir.Enabled := False;
      ActCancelar.Enabled := True;
      ActSalvar.Enabled := True;
      ActPrimeiro.Enabled := False;
      ActAnterior.Enabled := False;
      ActProximo.Enabled := False;
      ActUltimo.Enabled := False;
      ActSair.Enabled := False;
    end;
end;

procedure TFrmBasicCrudMasterDetail.DbgrQueryTitleClick(Column: TColumn);
begin
  inherited;
  if Column.Field.FieldKind =  fkData then //FieldKind qual é o tipo de campo
    begin
      FieldFilter := Column.Field;
      EdtPesquisa.Clear;
      EdtPesquisa.TextHint := 'Clique aqui para pesquisar em '+Column.Title.Caption;
    end;
end;

procedure TFrmBasicCrudMasterDetail.EdtPesquisaKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if key = #13 then
    EdtPesquisaRightButtonClick(Sender);
end;

procedure TFrmBasicCrudMasterDetail.EdtPesquisaLeftButtonClick(Sender: TObject);
begin
  inherited;
  EdtPesquisa.Clear;
  EdtPesquisa.TextHint := 'Click em uma coluna e pequise por ela...';
  DsQuery.DataSet.Filtered := False;
  DsQuery.DataSet.Refresh;
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

procedure TFrmBasicCrudMasterDetail.EdtPesquisaRightButtonClick(
  Sender: TObject);
Var
  Filter : String;
begin
  inherited;
  if Assigned(FieldFilter) then
    begin
      case FieldFilter.DataType of
        ftUnknown:; // desconhecido

        ftString, ftFixedChar, ftBoolean,
        ftWideString, ftFixedWideChar,
        ftWideMemo, ftMemo: Filter := 'upper ('+FieldFilter.FieldName+') like' +
                                       QuotedStr(UpperCase(EdtPesquisa.Text + '%'));
        ftSmallint, ftInteger,
        ftWord, ftLargeint, ftAutoInc,
        ftLongWord, ftShortint,
        ftBytes, ftByte: Filter := FieldFilter.FieldName + ' = ' +
                                   IntToStr(StrToIntDef(EdtPesquisa.Text,0)); // 0 é default

        ftFloat, ftCurrency,
        ftFMTBcd, ftExtended,
        ftSingle: Filter := FieldFilter.FieldName + ' = ' +
                            FloatToStr(StrToFloatDef(EdtPesquisa.Text,0));

        ftDate, ftTime, ftDateTime: Filter := FieldFilter.FieldName + ' = ' + EdtPesquisa.Text;
      end;
      DsQuery.DataSet.Filter := Filter;
      DsQuery.DataSet.Filtered := True;
    end;
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

procedure TFrmBasicCrudMasterDetail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DsQuery.DataSet.Close;
  DsCrud.DataSet.Close;
end;

procedure TFrmBasicCrudMasterDetail.FormCreate(Sender: TObject);
begin
  inherited;
  ControleBotoes(True);
  PageControl.Pages[0].TabVisible := False;
  PageControl.Pages[1].TabVisible := False;
  PageControl.ActivePage := TabQuery;
  DsQuery.DataSet.Open;
end;

procedure TFrmBasicCrudMasterDetail.ListaCampoObrigatorio;
var i : Integer;
begin
  //Deixar os label de filds requeridos em vermelho
  for i := 0 to pnControl.ControlCount -1 do
    if pnControl.Controls[i] is TLabel then // Verificando se nessa posição é um label
      if Assigned(TLabel(pnControl.Controls[i]).FocusControl) then //Verificando se tem algum componente apontando para propiedade focuscontrol do lebol
        if TLabel(pnControl.Controls[i]).FocusControl is TDBEdit then // Verifica se éum dbedit
          if TDBEdit(TLabel(pnControl.Controls[i]).FocusControl).Field.Required then // se o field é requerido
            TLabel(pnControl.Controls[i]).Font.Color := clRed // Deixa o edit em vermelho
          else
            if TLabel(pnControl.Controls[i]).FocusControl is TDBLookupComboBox then
              if TDBLookupComboBox(TLabel(pnControl.Controls[i]).FocusControl).Field.Required then
                TLabel(pnControl.Controls[i]).Font.Color := clRed // Deixa o edit em vermelho
end;

procedure TFrmBasicCrudMasterDetail.OpenCrud;
begin
  ControleBotoes(False);
  if not DsQuery.DataSet.IsEmpty then
    begin
      DsCrud.DataSet.Filter := 'CODIGO = '+DsQuery.DataSet.FieldByName('CODIGO').AsString;
      DsCrud.DataSet.Filtered := True;
    end;
  if not DsCrud.DataSet.Active then
        DsCrud.DataSet.Open;
end;

procedure TFrmBasicCrudMasterDetail.TabQueryShow(Sender: TObject);
begin
  inherited;
  ControleBotoes(True);
  DbgrQuery.SetFocus;
  EdtPesquisa.TextHint := 'Click em uma coluna e pequise por ela...';
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

end.
