unit UConfig;

interface

type
  TConfig = Class
  strict private
    class var FInstance: TConfig;
    constructor CreatPrivate;
  private
    FConfirmaGravacao: Boolean;
    FConfirmaCancelamento: Boolean;
    procedure SetConfirmaCancelamento(const Value: Boolean);
    procedure SetConfirmaGravacao(const Value: Boolean);
  public
    constructor Create; // Invalidar o construtor
    class function GetInstance: TConfig;
  published
    property ConfirmaGravacao: Boolean read FConfirmaGravacao write SetConfirmaGravacao;
    property ConfirmaCancelamento: Boolean read FConfirmaCancelamento write SetConfirmaCancelamento;
  end;

implementation

uses
  System.SysUtils;

{ TConfig }

constructor TConfig.Create;
begin
  raise Exception.Create('Para obter uma instâcia de TConfig, use TConfig.GetInstance');
end;

constructor TConfig.CreatPrivate;
begin
  inherited Create;
end;

class function TConfig.GetInstance: TConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TConfig.Create;
  Result := FInstance;
end;

procedure TConfig.SetConfirmaCancelamento(const Value: Boolean);
begin
  FConfirmaCancelamento := Value;
end;

procedure TConfig.SetConfirmaGravacao(const Value: Boolean);
begin
  FConfirmaGravacao := Value;
end;

end.
