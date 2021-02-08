unit kitU.mail;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  IdSMTP,
  IdUserPassProvider,
  IdSASLLogin,
  IdSSLOpenSSL,
  IdExplicitTLSClientServerBase,
  IdMessage,
  IdMessageBuilder,
  kitU.interfaces,
  kitU.mail.types;

type

//  txuitls_mail_status = (xuitls_mail_status_disabled, xuitls_mail_status_erro, xuitls_mail_status_enabled);
//
//  txuitls_mail_status_parameter_metadata = record
//    str_file: string;
//    str_subject: string;
//    str_mail_text_message: string;
//    str_mail_text_link_message: string;
//    str_mail_rodape: string;
//  end;


  tkituMail = class(tinterfacedobject, ikituMail)
  private
    { private declarations }
    fstrHost: string;
    fstrUser: string;
    fstrPassword: string;
    fintPort: integer;
    fbooAuthenticate: boolean;
    fbooSSL: boolean;
    fmailBody: tkitUmailBody;

    fstrFrom: string;
    fstrDestination: string;
    fstrSubject: string;
    fstrMailBody: string;

    fidMensagem: tIdMessage;
    fidCustomMessageBuilder: tidCustomMessageBuilder;

    fsmtp: tidSMTP;
    fuserPassProvider: tiduserPassProvider;
    fIdSASLloginProvider: TIdSASLLogin;
    fIOHandler: TIdSSLIOHandlerSocketOpenSSL;

    fstrRepositoryLocalFiles: string;

    function dobuildMessage: boolean;
    function doPrepare: boolean;
    function doClose: boolean;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor create(pstrHost, pstrLogin, pstrPassword: string; pintPort: integer; pbooAuthenticate, pbooSSL: boolean);
    destructor destroy; override;

    class function new(pstrHost, pstrLogin, pstrPassword: string; pintPort: integer; pbooAuthenticate, pbooSSL: boolean): ikituMail;

    function from(const value: string): ikituMail;
    function destination(const value: string): ikituMail;
    function subject(const value: string): ikituMail;
    function body(const value: tkitUmailBody): ikituMail;

    function send: ikituMail;
  end;

implementation

function tkituMail.dobuildMessage: boolean;
begin
  result := false;
  try
    try
      fidCustomMessageBuilder := tIdMessageBuilderHtml.Create;

      tIdMessageBuilderHtml(fidCustomMessageBuilder).HtmlCharSet := 'UTF-8';
      tIdMessageBuilderHtml(fidCustomMessageBuilder).Html.DefaultEncoding := TEncoding.UTF8;
      tIdMessageBuilderHtml(fidCustomMessageBuilder).Html.Text := fstrMailBody;

      fidMensagem := tidmessage.Create(nil);
      fidCustomMessageBuilder.FillMessage(fidMensagem);

      if fidCustomMessageBuilder <> nil then
        freeandnil(fidCustomMessageBuilder);

      with fidMensagem do
      begin
        encoding := meMime;
        attachmentEncoding := 'MIME';
        contentDisposition := 'inline';

        from.text := fstrFrom;
        replyTo.emailAddresses := fstrFrom;
        receiptRecipient.text := fstrFrom;

        recipients.emailAddresses := fstrDestination;
        subject := fstrSubject;
        priority := mpNormal;
      end;

      result := true;
    except
    end;
  finally
  end;
end;

function tkituMail.doClose: boolean;
begin
  if fsmtp <> nil then
  begin
    if fsmtp.Connected then
      fsmtp.Disconnect(true);
  end;

  if fuserPassProvider <> nil then
    freeandnil(fuserPassProvider);

  if fIdSASLLoginProvider <> nil then
    freeandnil(fIdSASLLoginProvider);

  if fsmtp <> nil then
  begin
    fsmtp.IOHandler.Free;
    freeandnil(fsmtp);
  end;

  result := true;
end;

function tkituMail.body(const value: tkitUmailBody): ikituMail;
begin
  result := self;
  fmailBody := value;
end;

constructor tkituMail.create(pstrHost, pstrLogin, pstrPassword: string; pintPort: integer; pbooAuthenticate, pbooSSL: boolean);
begin
  fstrHost := pstrHost;
  fstrUser := pstrLogin;
  fstrPassword := pstrPassword;
  fintPort := pintPort;

  fbooAuthenticate := pbooAuthenticate;
  fbooSSL := pbooSSL;

  fstrFrom := '';
  fstrDestination := '';
  fstrSubject := '';
  fstrMailBody := '';

  fidMensagem := nil;
  fidCustomMessageBuilder := nil;

  fsmtp := nil;
  fIOHandler := nil;
  fuserPassProvider := nil;
  fIdSASLLoginProvider := nil;

  fstrRepositoryLocalFiles := extractFileDir(ParamStr(0)) + TPath.DirectorySeparatorChar + 'Utilities' + TPath.DirectorySeparatorChar  + 'Mails' + TPath.DirectorySeparatorChar;
  if not(DirectoryExists(fstrRepositoryLocalFiles)) then
    ForceDirectories(fstrRepositoryLocalFiles);
end;

function tkituMail.destination(const value: string): ikituMail;
begin
  result := self;
  fstrDestination := value;
end;

destructor tkituMail.Destroy;
begin
  if fsmtp <> nil then
    fsmtp.Disconnect(true);

  if fuserPassProvider <> nil then
    freeandnil(fuserPassProvider);

  if fIdSASLLoginProvider <> nil then
    freeandnil(fIdSASLLoginProvider);

  if fsmtp <> nil then
  begin
    fsmtp.iohandler.free;
    freeandnil(fsmtp);
  end;

  if fidMensagem <> nil then
    freeandnil(fidMensagem);

  if fidCustomMessageBuilder <> nil then
    freeandnil(fidCustomMessageBuilder);

  inherited;
end;

function tkituMail.doPrepare: boolean;
var
  lintCountConnnect: integer;
  lstrMessageErro: string;
label
  gmailConnect;

begin
  result := False;
  try
    try
      if fsmtp = nil then
        fsmtp := TIdSMTP.Create(nil);

      fsmtp.Port := fintPort;
      fsmtp.Host := fstrHost;
      fsmtp.ConnectTimeout := 9000;

      if not fbooSSL then
      begin
        if fuserPassProvider = nil then
          fuserPassProvider := TIdUserPassProvider.Create(nil);

        if fIdSASLLoginProvider = nil then
          fIdSASLLoginProvider := TIdSASLLogin.Create(nil);
      end
      else
      begin
        if fIOHandler = nil then
          fIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(fsmtp);
        fsmtp.IOHandler := fIOHandler;
      end;

      if fbooAuthenticate then
        if not(fbooSSL) then
        begin
          fuserPassProvider.userName := fstrUser;
          fuserPassProvider.password := fstrPassword;
          fIdSASLLoginProvider.userPassProvider := fuserPassProvider;
          fsmtp.SASLMechanisms.add.sasl := fIdSASLLoginProvider;
          fsmtp.AuthType := satDefault;
        end
        else
        begin
          if (Pos('live.com', fstrHost) > 0) or (Pos('outlook.com', fstrHost) > 0) or (Pos('yahoo.com', fstrHost) > 0) or (Pos('bol.com', fstrHost) > 0) or (Pos('amazonaws.com', fstrHost) > 0) or ((Pos('gmail.com', fstrHost) > 0) and (fintPort = 587)) then
          begin
            fsmtp.UseTLS := utUseExplicitTLS;
            TIdSSLIOHandlerSocketOpenSSL(fsmtp.IOHandler).SSLOptions.Method := sslvTLSv1;
          end
          else
          begin
            fsmtp.UseTLS := utUseImplicitTLS;
            TIdSSLIOHandlerSocketOpenSSL(fsmtp.IOHandler).SSLOptions.Method := sslvSSLv3;
          end;

          if (((Pos('gmail.com', fstrHost) > 0) or (Pos('amazonaws.com', fstrHost) > 0)) and (fintPort = 587)) then
          begin
            if fuserPassProvider = nil then
              fuserPassProvider := TIdUserPassProvider.Create(nil);

            fuserPassProvider.Username := fstrUser;
            fuserPassProvider.Password := fstrPassword;

            if fIdSASLLoginProvider = nil then
              fIdSASLLoginProvider := TIdSASLLogin.Create(nil);

            fIdSASLLoginProvider.UserPassProvider := fuserPassProvider;
            fsmtp.SASLMechanisms.Add.SASL := fIdSASLLoginProvider;

            fsmtp.AuthType := satSASL;
          end
          else
            fsmtp.AuthType := satDefault;

          TIdSSLIOHandlerSocketOpenSSL(fsmtp.IOHandler).SSLOptions.Mode := sslmClient;
          fsmtp.Username := fstrUser;
          fsmtp.Password := fstrPassword;
        end
       else
        fsmtp.AuthType:= satNone;

      with fsmtp do
      begin
        lintCountConnnect := 0;
        gmailConnect:

        try
          Connect;
        except
          on E: Exception do
            lstrMessageErro := E.Message;
        end;

        if not(Connected) and (lstrMessageErro = 'Could not load SSL library.') and (lintCountConnnect = 0) then
        begin
          inc(lintCountConnnect);
          goto gmailConnect;
        end
        else
        begin
           if not(Connected) then
              Exit;
        end;

        Authenticate;
        Result := true;
      end;
    except
      on ErroCon: Exception do
        raise Exception.Create(ErroCon.Message);
    end;
  finally
    if not(result) then
    begin
      if fsmtp <> nil then
        fsmtp.Disconnect(true);

      if fuserPassProvider <> nil then
        freeandnil(fuserPassProvider);

      if fIdSASLLoginProvider <> nil then
        freeandnil(fIdSASLLoginProvider);

      if fsmtp <> nil then
      begin
        fsmtp.IOHandler.Free;
        freeandnil(fsmtp);
      end;
    end;
  end;
end;


function tkituMail.from(const value: string): ikituMail;
begin
  result := self;
  fstrFrom := value;
end;

class function tkituMail.new(pstrHost, pstrLogin, pstrPassword: string; pintPort: integer; pbooAuthenticate, pbooSSL: boolean): ikituMail;
begin
  result := self.create(pstrHost, pstrLogin, pstrPassword, pintPort, pbooAuthenticate, pbooSSL);
end;

function tkituMail.send: ikituMail;
begin
  result := self;

  try
    try
      if assigned(fmailBody) then
      begin
        fstrMailBody := fmailBody(fstrRepositoryLocalFiles);

        if dobuildMessage and doPrepare and (fsmtp <> nil) then
          fsmtp.Send(fidMensagem);
      end;
    except
      on E: Exception do
        raise;
    end;
  finally
    doClose;
  end;
end;

function tkituMail.subject(const value: string): ikituMail;
begin
  result := self;
  fstrSubject := value;
end;

end.
