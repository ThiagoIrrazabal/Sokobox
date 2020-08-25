unit Interfaces.Player;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  TPlayerDirection = (tpdNone, tpdUP, tpdDOWN, tpdLEFT, tpdRIGHT);

  IPlayer = Interface(IInterface)
  ['{149FF061-A040-4770-BF31-D3EECB49E6AD}']
    function Position(const Value: TPoint): IPlayer; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IPlayer; overload;
    function Owner: TGridPanel; overload;
    function Direction(const Value: TPlayerDirection): IPlayer; overload;
    function Direction: TPlayerDirection; overload;
    function CreateImages: IPlayer;
    function ChangeImage: IPlayer;
    function ChangeParent: IPlayer;
  End;

implementation

end.
