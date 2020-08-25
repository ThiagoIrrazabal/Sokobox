unit Interfaces.Box;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  IBox = Interface(IInterface)
  ['{2D0FD04F-D399-40D1-ACF4-86B24EB2230A}']
    function Position(const Value: TPoint): IBox; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IBox; overload;
    function Owner: TGridPanel; overload;
    function Key(const Value: Integer): IBox; overload;
    function Key: Integer; overload;
    function CreateImages: IBox;
    function ChangeParent: IBox;
  End;

implementation

end.
