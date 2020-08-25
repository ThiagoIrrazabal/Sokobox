unit StringFactory;

interface

type
  IStringBuilder = Interface(IInterface)
  ['{58C64C93-9F29-470D-AEEF-4ECEF0D3D684}']
    function LoadFromFile(const PathFile: string): IStringBuilder;
    function ToString: string;
  End;

  TStringBuilder = class(TInterfacedObject, IStringBuilder)
  strict private
  var
    FStringFile: string;
  public
    class function New: IStringBuilder;
    function LoadFromFile(const PathFile: string): IStringBuilder;
    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, System.Classes;

{ TStringBuilder }

function TStringBuilder.LoadFromFile(const PathFile: string): IStringBuilder;
var
  StringBuilder: TStringList;
begin
  Result := Self;
  StringBuilder := TStringList.Create;
  try
    StringBuilder.LoadFromFile(PathFile);
    FStringFile := StringBuilder.Text;
  finally
    FreeAndNil(StringBuilder);
  end;
end;

class function TStringBuilder.New: IStringBuilder;
begin
  Result := Self.Create;
end;

function TStringBuilder.ToString: string;
begin
  Result := FStringFile;
end;

end.
