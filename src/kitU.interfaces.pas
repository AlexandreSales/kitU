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

implementation

end.
