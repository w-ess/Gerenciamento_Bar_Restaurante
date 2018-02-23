unit USplash;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ExtCtrls, jpeg, StdCtrls,  pngimage;

Type
   TFSplash = class(TForm)
      Panel1: TPanel;
      ImagemLogo: TImage;
    Panel2: TPanel;
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormCreate(Sender: TObject);
   private
      { Private declarations }

   public
      { Public declarations }
   end;

var
   FSplash: TFSplash;

implementation

uses UPrincipal;

{$R *.dfm}

procedure TFSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := cafree;
end;

procedure TFSplash.FormCreate(Sender: TObject);
Var
   // Hoje: TDateTime;
   Ano, Mes, Dia: Word;
begin
   DecodeDate(Date, Ano, Mes, Dia);

end;

end.
