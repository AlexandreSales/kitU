unit kitU.Json;

interface

uses
  kitU.interfaces;

type

  tkitUObjectArray<t> = class(tinterfacedobject, ikitUObjectArray<t>)
  private
    { private declarations }
    fitems: tarray<t>;
  public
    { public declarations }
    constructor create(const pitems: tarray<t>);
    class function new(const pitems: tarray<t>): ikitUObjectArray<t>;
    property items: tarray<t> read fitems write fitems;
  end;

implementation

{ tkitUObjectArray<t> }

constructor tkitUObjectArray<t>.create(const pitems: tarray<t>);
begin
  items := pitems;
end;

class function tkitUObjectArray<t>.new(const pitems: tarray<t>): ikitUObjectArray<t>;
begin
  result := self.create(pitems);
end;

end.
