unit Interfaces.Box.Goal;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  IBoxGoal = Interface(IInterface)
  ['{2D0FD04F-D399-40D1-ACF4-86B24EB2230A}']
    function Position(const Value: TPoint): IBoxGoal; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IBoxGoal; overload;
    function Owner: TGridPanel; overload;
    function Key(const Value: Integer): IBoxGoal; overload;
    function Key: Integer; overload;
    function CreateImages: IBoxGoal;
    function ChangeParent: IBoxGoal;
  End;

implementation

end.
