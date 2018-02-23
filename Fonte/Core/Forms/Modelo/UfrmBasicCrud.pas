unit UfrmBasicCrud;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Data.DB,
  Vcl.ComCtrls, System.Generics.Collections, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Mask, Vcl.DBCtrls, UfrmBasic;

type
  TRecodState = (rsNew, rsEdit, rsDelete);// Enumerado
  TFrmBasicCrud = class(TFrmBasic)
    ActionList1: TActionList;
    Img: TImageList;
    PnCaption: TPanel;
    StaBarInfo: TStatusBar;
    DsCrud: TDataSource;
    DsQuery: TDataSource;
    ImgAction: TImageList;
    Image1: TImage;
    Label1: TLabel;
    pnTools: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    PageControl: TPageControl;
    TabCrud: TTabSheet;
    TabQuery: TTabSheet;
    Panel1: TPanel;
    EdtPesquisa: TButtonedEdit;
    DbgrQuery: TDBGrid;
    ActIncluir: TAction;
    ActAlterar: TAction;
    ActExcluir: TAction;
    ActCancelar: TAction;
    ActSalvar: TAction;
    AcrSair: TAction;
    ActImprimir: TAction;
    ActVisualizar: TAction;
    ActAnterior: TAction;
    ActProximo: TAction;
    ActPrimeiro: TAction;
    ActUltimo: TAction;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton11: TSpeedButton;
    pnControl: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure ActSalvarUpdate(Sender: TObject);
    procedure ActIncluirUpdate(Sender: TObject);
    procedure ActIncluirExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure ActAlterarExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure ActSalvarExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure DbgrQueryTitleClick(Column: TColumn);
    procedure EdtPesquisaLeftButtonClick(Sender: TObject);
    procedure EdtPesquisaRightButtonClick(Sender: TObject);
    procedure AcrSairExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabQueryShow(Sender: TObject);
    procedure EdtPesquisaKeyPress(Sender: TObject; var Key: Char);
  private
    //FKeyTabela : String;
    FRecodState : TRecodState; // vai servi pra controlar a intens�o do usu�rio
    procedure ListaCampoObrigatorio;
    { Private declarations }
  protected
    //objeto usado na rotina de consulta
    FieldFilter: TField;
    procedure OpenCrud;
  public
    { Public declarations }
    //property KeyTabela : String read FKeyTabela write FKeyTabela;
  end;

var
  FrmBasicCrud: TFrmBasicCrud;

implementation

{$R *.dfm}

uses DBClient, UBiblioteca;

{ TfrmBasicCrud }

procedure TFrmBasicCrud.AcrSairExecute(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmBasicCrud.ActAlterarExecute(Sender: TObject);
begin
  inherited;
  OpenCrud;
  DsCrud.DataSet.Edit;
  PageControl.ActivePage := TabCrud;
  FRecodState := rsEdit;
end;

procedure TFrmBasicCrud.ActAnteriorExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Prior;
end;

procedure TFrmBasicCrud.ActCancelarExecute(Sender: TObject);
begin
  inherited;
  case FRecodState of
    rsNew:
      if not pergunta('Confirma o cancelamento da inclus�o do registro?')then
        exit;
    rsEdit:
      if not pergunta('Confirma o cancelamento da edi��o do registro?') then
        exit;
  end;
  TFDQuery(DsCrud.DataSet).Cancel;
  PageControl.ActivePage := TabQuery;
end;

procedure TFrmBasicCrud.ActExcluirExecute(Sender: TObject);
begin
  inherited;
  if pergunta('Confirma a exclus�o do registro?') then
    DsQuery.DataSet.Delete;
end;

procedure TFrmBasicCrud.ActIncluirExecute(Sender: TObject);
begin
  inherited;
  if not DsCrud.DataSet.Active then
    DsCrud.DataSet.Open;

  DsCrud.DataSet.Insert;
  PageControl.ActivePage := TabCrud;
  ListaCampoObrigatorio;
  StaBarInfo.SimpleText := '* Campos em vermelho s�o obrigat�rios!';
  FRecodState := rsNew;
end;

procedure TFrmBasicCrud.ActIncluirUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not (DsCrud.State in [dsInsert, dsEdit]);
end;

procedure TFrmBasicCrud.ActPrimeiroExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.First;
end;

procedure TFrmBasicCrud.ActProximoExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Next;
end;

procedure TFrmBasicCrud.ActSalvarExecute(Sender: TObject);
begin
  inherited;
  if not (DsCrud.DataSet.State in [dsInsert, dsEdit]) then
    Exit;
  case FRecodState of
    rsNew:
      if not pergunta('Confirma a inclus�o do registro?') then
        exit;
    rsEdit:
      if not pergunta('Confirma a edi��o do registro?') then
        exit;
  end;
  if not (FRecodState = rsDelete) then
    TFDQuery(DsCrud.DataSet).Post;

  DsCrud.DataSet.Refresh;
  DsCrud.DataSet.Filtered := False;
  DsQuery.DataSet.Refresh;
  PageControl.ActivePage := TabQuery;
end;

procedure TFrmBasicCrud.ActSalvarUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := DsCrud.State in [dsInsert, dsEdit];
end;

procedure TFrmBasicCrud.ActUltimoExecute(Sender: TObject);
begin
  inherited;
  DsQuery.DataSet.Last;
end;

procedure TFrmBasicCrud.DbgrQueryTitleClick(Column: TColumn);
begin
  inherited;
  if Column.Field.FieldKind =  fkData then //FieldKind qual � o tipo de campo
    begin
      FieldFilter := Column.Field;
      EdtPesquisa.Clear;
      EdtPesquisa.TextHint := 'Clique aqui para pesquisar em '+Column.Title.Caption;
    end;
end;

procedure TFrmBasicCrud.EdtPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
    EdtPesquisaRightButtonClick(Sender);
end;

procedure TFrmBasicCrud.EdtPesquisaLeftButtonClick(Sender: TObject);
begin
  inherited;
  EdtPesquisa.Clear;
  EdtPesquisa.TextHint := 'Click em uma coluna e pequise por ela...';
  DsQuery.DataSet.Filtered := False;
  DsQuery.DataSet.Refresh;
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

procedure TFrmBasicCrud.EdtPesquisaRightButtonClick(Sender: TObject);
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
                                   IntToStr(StrToIntDef(EdtPesquisa.Text,0)); // 0 � default

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

procedure TFrmBasicCrud.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DsQuery.DataSet.Close;
  DsCrud.DataSet.Close;
end;

procedure TFrmBasicCrud.FormCreate(Sender: TObject);
begin
  inherited;
  PageControl.Pages[0].TabVisible := False;
  PageControl.Pages[1].TabVisible := False;
  PageControl.ActivePage := TabQuery;
  DsQuery.DataSet.Open;
end;

procedure TFrmBasicCrud.ListaCampoObrigatorio;
var i : Integer;
begin
  //Deixar os label de filds requeridos em vermelho
  for i := 0 to pnControl.ControlCount -1 do
    if pnControl.Controls[i] is TLabel then // Verificando se nessa posi��o � um label
      if Assigned(TLabel(pnControl.Controls[i]).FocusControl) then //Verificando se tem algum componente apontando para propiedade focuscontrol do lebol
        if TLabel(pnControl.Controls[i]).FocusControl is TDBEdit then // Verifica se �um dbedit
          if TDBEdit(TLabel(pnControl.Controls[i]).FocusControl).Field.Required then // se o field � requerido
            TLabel(pnControl.Controls[i]).Font.Color := clRed // Deixa o edit em vermelho
          else
            if TLabel(pnControl.Controls[i]).FocusControl is TDBLookupComboBox then
              if TDBLookupComboBox(TLabel(pnControl.Controls[i]).FocusControl).Field.Required then
                TLabel(pnControl.Controls[i]).Font.Color := clRed // Deixa o edit em vermelho
end;

procedure TFrmBasicCrud.OpenCrud;
begin
  if not DsQuery.DataSet.IsEmpty then
    begin
      DsCrud.DataSet.Filter := 'CODIGO = '+DsQuery.DataSet.FieldByName('CODIGO').AsString;
      DsCrud.DataSet.Filtered := True;
    end;
  if not DsCrud.DataSet.Active then
        DsCrud.DataSet.Open;
end;

procedure TFrmBasicCrud.TabQueryShow(Sender: TObject);
begin
  inherited;
  DbgrQuery.SetFocus;
  EdtPesquisa.TextHint := 'Click em uma coluna e pequise por ela...';
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

end.
