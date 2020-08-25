unit Interfaces.Goal;

interface

uses
  System.Classes,
  System.Types,
  Vcl.ExtCtrls;

type
  IGoal = Interface(IInterface)
  ['{D41B5854-54B2-43B5-93BA-5BE559A2FB4C}']
    function Position(const Value: TPoint): IGoal; overload;
    function Position: TPoint; overload;
    function Owner(const Value: TGridPanel): IGoal; overload;
    function Owner: TGridPanel; overload;
    function CreateImages: IGoal;
  End;

implementation

end.
