unit IronKaputBase;

interface

Uses DirectDraw,DirectDrawUsing,BaseSprite, types,Windows,Classes,
SoundManagerIronKaput;

type
  CGameElement = class(CSprite)
  protected
     X,Y: integer;             // положение на экране
     destroy: boolean;
  public
    function GetX: integer;
    function GetY: integer;
    function SetY(newparam: integer): hresult;
    function SetX(newparam: integer): hresult;
    function GetDestroy: boolean;
    function SetDestroy(newparam: boolean): hresult;
  end;

implementation

{*************************************************************}
            ////CGameElement /////
{*************************************************************}

function CGameElement.SetY(newparam: integer): hresult;
begin
  y:=newparam;
end;

function CGameElement.SetX(newparam: integer): hresult;
begin
  Self.x:=newparam;
end;

function CGameElement.GetDestroy: boolean;
begin
  result:=destroy;
end;

function CGameElement.SetDestroy(newparam: boolean): hresult;
begin
  destroy:=newparam;
end;

function CGameElement.GetX: integer;
begin
  result:=X;
end;

function CGameElement.GetY: integer;
begin
  result:=Y;
end;


end.
