unit kitU.interfaces;

interface

uses kitU.mail.types;

type

  ikituMail = interface
    ['{3E91A0AE-EF35-4FEB-8EAE-9983F059C21B}']
    function from(const value: string): ikituMail;
    function destination(const value: string): ikituMail;
    function subject(const value: string): ikituMail;
    function body(const value: tkitUmailBody): ikituMail;

    function send: ikituMail;
  end;

  ikitUObjectArray<t> = interface
    ['{51F46471-31AB-43FB-BA21-337328F6A8A2}']
  end;

implementation

end.
