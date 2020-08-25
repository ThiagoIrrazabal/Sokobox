unit Interfaces.Floor;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  IFloor = Interface(IInterface)
  ['{47E6A6F7-E115-44CD-8EE9-0A6FD7520A79}']
    function Position(const Value: TPoint): IFloor; overload;
    function Position: TPoint; overload;
    function Goal(const Value: Boolean): IFloor; overload;
    function Goal: Boolean; overload;
    function Owner(const Value: TGridPanel): IFloor; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IFloor;
  End;

implementation

end.
