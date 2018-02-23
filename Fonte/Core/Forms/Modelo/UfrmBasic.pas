unit UfrmBasic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TFrmBasic = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    function GetTitulo: String; virtual; abstract;
  public
    { Public declarations }
  end;

var
  FrmBasic: TFrmBasic;

implementation

{$R *.dfm}

procedure TFrmBasic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmBasic.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close; // se pressionar esc o form é fechado
    VK_RETURN: Perform(WM_NEXTDLGCTL,0,0); //pressionar enter muda o foco para o proximo controle
  end;
end;

procedure TFrmBasic.FormShow(Sender: TObject);
begin
  //Caption := GetTitulo;
end;

end.
