unit Interfaces.Wall;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  IWall = Interface(IInterface)
  ['{16E7C9EC-FFC0-4905-8B6B-0B4A72EA5AEA}']
    function Position(const Value: TPoint): IWall; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IWall; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IWall;
  End;

implementation

end.
