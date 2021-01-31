unit kitU.await;

interface

uses
  System.SysUtils,
  System.Classes;

type
  IAwait = interface
    ['{F0D98386-0B3A-478A-8758-C7CF81A64468}']
    procedure Await(proc: TNotifyEvent);
  end;

  TAwait = class(tinterfacedobject, IAwait)
  strict private
    FAsync: TProc;
  public
    constructor Create(Async: TProc);

    class function Async(proc: TProc): IAwait;
    procedure Await(Proc: TNotifyEvent);
  end;

implementation

{ TAwait }

class function TAwait.Async(Proc: TProc): IAwait;
begin
  Result := Self.Create(Proc);
end;

procedure TAwait.Await(Proc: TNotifyEvent);
begin
  var i_thread  := TThread.CreateAnonymousThread(FAsync);
  i_thread.OnTerminate := Proc;
  i_thread.start();
end;

constructor TAwait.Create(Async: TProc);
begin
  inherited Create;
  FAsync := Async;
end;

end.
