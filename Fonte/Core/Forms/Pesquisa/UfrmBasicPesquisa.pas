unit UfrmBasicPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBasic, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TFrmBasicPesquisa = class(TFrmBasic)
    PnCaption: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Img: TImageList;
    EdtPesquisa: TButtonedEdit;
    FDQuery: TFDQuery;
    DsQuery: TDataSource;
    StaBarInfo: TStatusBar;
    LblTitulo: TLabel;
    procedure EdtPesquisaLeftButtonClick(Sender: TObject);
    procedure EdtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPesquisaRightButtonClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCodigo : Integer;
  protected
    //objeto usado na rotina de consulta
    FieldFilter: TField;
  public
    { Public declarations }
    Titulo : String;
    Query  : String;
    property Codigo : Integer read FCodigo write FCodigo;
  end;

var
  FrmBasicPesquisa: TFrmBasicPesquisa;

implementation

{$R *.dfm}

uses UDmBD, UBiblioteca;

procedure TFrmBasicPesquisa.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  FCodigo := FDQuery.FieldByName('CODIGO').AsInteger;
  Close
end;

procedure TFrmBasicPesquisa.DBGrid1TitleClick(Column: TColumn);
begin
  inherited;
  if Column.Field.FieldKind =  fkData then //FieldKind qual � o tipo de campo
    begin
      FieldFilter := Column.Field;
      EdtPesquisa.Clear;
      EdtPesquisa.TextHint := 'Clique aqui para pesquisar em '+Column.Title.Caption;
    end;
end;

procedure TFrmBasicPesquisa.EdtPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
    EdtPesquisaRightButtonClick(Sender);
end;

procedure TFrmBasicPesquisa.EdtPesquisaLeftButtonClick(Sender: TObject);
begin
  inherited;
  EdtPesquisa.Clear;
  EdtPesquisa.TextHint := 'Click em uma coluna e pequise por ela...';
  DsQuery.DataSet.Filtered := False;
  DsQuery.DataSet.Refresh;
  StaBarInfo.SimpleText := 'Total de Registros: '+IntToStr(DsQuery.DataSet.RecordCount);
end;

procedure TFrmBasicPesquisa.EdtPesquisaRightButtonClick(Sender: TObject);
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

procedure TFrmBasicPesquisa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FDQuery.Close;
end;

procedure TFrmBasicPesquisa.FormShow(Sender: TObject);
begin
  inherited;
  LblTitulo.Caption := Titulo;
  try
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add(Query);
    FDQuery.Open;
  except
    Erro('N�o foi poss�vel executar a '+Titulo+'.');
  end;
end;

end.
