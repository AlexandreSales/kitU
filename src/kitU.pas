unit kitU;

interface

uses
  system.classes,
  system.sysutils,
  kitU.types;

type

  tkitU = class
  private
    { private declaration }
    class function isInArray(const value: string; index: integer; const arrChars: array of char): boolean;
  public
    { public declarations }
    class function age(const birthDate: tdate; ageType: tageType = tiyears): integer;
    class function ageString(const birthDate: tdate; ageType: tageType): string;

    class function bytetoMemoryStream(value: tbytes): tmemoryStream; overload;

    class function gmttoDateTime(const value: string): tdatetime;

    class function firstDOM(const value: tdate): tdatetime;
    class function firstDOW(const value: tdate): tdatetime;
    class function firstDOY(const value: tdate): tdatetime;

    class function iif(const condition: boolean; const trueValue, falseValue: variant): variant;
    class function isDoc(const value: string): boolean;
    class function isDate(const value: String): boolean;
    class function isMail(const value: string): boolean;
    class function isCelPhone(const value: string): boolean;
    class function isCodPhone(const value: string): boolean;
    class function isCredtCard(const value: string): integer;

    class function lastDOM(const value: tdate): tdateTime;
    class function lastDOW(const value: tdate): tdateTime;
    class function lastDOY(const value: tdate): tdateTime;


    class function memoryStreamToBase64(const value: tmemorystream): string;
    class function notCharacter(const value: string; ext: boolean): string;

    class function readStr(value: string; offSet: integer): string;
    class function readInt(value: string; offSet: integer): integer;
    class function readFloat(value: string; offSet: Integer): single;

    class function strtoChars(const value: string; chars: string = '0123456789'): string;
    class function strtoFloat(const value: string): single;
    class function strtoInt(const value: string): integer;
    class function strtoStrNumber(const value: string): string;
    class function strtoMemoryStream(value: string): tmemoryStream; overload;

    class function secondsBetween(const pdtStart, pdtEnd: tdateTime): Int64;

    {$ifdef securit_cript_lockbox}
      class function ssc(strString, strKey: String): String;
      class function ssd(strString, strKey: String): String;
    {$endif}


    class function textFormat(const value: String; tipo: tformatType; IeUF: String = ''): string;
    class function timeintervalToStr(interval: Int64): String;

    class function uuId(const onlyNumbers: boolean = false): string;
    class function writeStrings(value: String; offSet: Integer; newValue: string): string;

    class procedure base64toMemoryStream(const value: string; var strmResultStream: tmemorystream);
  end;


implementation

uses
  system.character,
  system.variants,
  IdCoderMIME,

  {$ifdef securit_cript_lockbox}
    LbClass, LbCipher
  {$endif}

  kitU.consts;

{ tkitU }

class function tkitU.age(const birthDate: tdate; ageType: tageType): integer;
var
  lintYears: integer;
  lintMonths: integer;
  ldtFinalDate: tdate;

  function calcSeason(const pintSeason: integer): integer;
  var
    lintCount: integer;
  begin
    lintCount := 0;
    repeat
      inc(lintCount);
      ldtFinalDate := IncMonth(ldtFinalDate, pintSeason * -1);
    until ldtFinalDate < birthDate;

    ldtFinalDate := IncMonth(ldtFinalDate, pintSeason);
    inc(lintCount, -1);
    result := lintCount;
  end;

begin
  result := 0;

  ldtFinalDate := Date;
  if ldtFinalDate <= birthDate then
    exit;

  lintYears := calcSeason(12);
  lintMonths := calcSeason(1);

  if ageType in [tiyears] then
    result := lintYears
  else
    if ageType in [timonths] then
      result := lintMonths
    else
      result := 0;
end;

class function tkitU.ageString(const birthDate: tdate; ageType: tageType): string;
var
  lintYears      : integer;
  lintMonths     : integer;
  lintDays       : integer;
  ldtFinalDate  : tdate;
  lstrResult     : string;

  {Retorna a diferença em Dias,Meses e Anos entre 2 datas}
  function calcSeason(const pintSeason: integer): integer;
  var
     lintCount: integer ;
  begin
    lintCount := 0 ;

    repeat
      inc(lintCount) ;
      ldtFinalDate := incmonth(ldtFinalDate,pintSeason * -1) ;
    until ldtFinalDate < birthDate ;

    ldtFinalDate := incmonth(ldtFinalDate,pintSeason) ;
    inc(lintCount,-1) ;
    result := lintCount ;
  end;

begin
  ldtFinalDate := date;

  if ldtFinalDate <= birthDate then
    exit ;

  lintYears := calcSeason(12) ;
  lintMonths := calcSeason(1) ;
  lintDays := Round(ldtFinalDate - birthDate) ;

  if ageType in [tiResume]  then
  begin
    if lintYears >= 1 then
      lstrResult := inttostr(lintYears) + ' a';

    if lintMonths >= 1 then
      lstrResult := inttostr(lintMonths) + ' m';
  end;

  if ageType in [tiyears, tiyearsMonth, tiyearsMonthDay, tifull]  then
    if lintYears = 1 then
      lstrResult := inttoStr(lintYears)+' ano'
    else
      if lintYears >= 1 then
        lstrResult := inttoStr(lintYears)+' anos';

  if ageType in [tiyearsMonth, tiyearsMonthDay, tifull]  then
    if lstrResult <> nullAsStringValue then
    begin
      if lintMonths = 1 then
        lstrResult := lstrResult + ', ' + inttoStr(lintMonths) + ' mês'
      else
        if lintMonths > 1 then
          lstrResult := lstrResult + ', '+ inttoStr(lintMonths) + ' meses';
    end
    else
    begin
      if lintMonths = 1 then
        lstrResult := inttostr(lintMonths) + ' mês'
      else
        if lintMonths > 1 then
          lstrResult := inttostr(lintMonths) + ' meses';
    end;

  if ageType in [tiyearsMonthDay, tifull]  then
    if lstrResult <> nullAsStringValue then
    begin
      if lintDays = 1 then
        lstrResult := lstrResult + ', ' + inttoStr(lintDays) + ' dia'
      else
        if lintDays > 1 then
          lstrResult := lstrResult + ', ' + inttoStr(lintDays) + ' dias';
    end
    else begin
      if lintDays = 1 then
        lstrResult := inttostr(lintDays) + ' dia'
      else
        if lintDays > 1 then
          lstrResult := inttostr(lintDays) + ' dias';
    end;

  result := lstrResult;
end;

class function tkitU.firstDOM(const value: TDate): TDateTime;
var
  lwdYear: word;
  lwdMonth: word;
  lwdDay: word;
begin
  if value = 0 then
    DecodeDate(now, lwdYear, lwdMonth, lwdDay)
  else
    DecodeDate(value, lwdYear, lwdMonth, lwdDay);

  lwdDay := 1;
  Result := (strToDate(intToStr(lwdDay) + '/' + intToStr(lwdMonth) + '/' + intToStr(lwdDay)));
end;

class function tkitU.firstDOW(const value: TDate): tdateTime;
var
  dtDate: tdate;
begin
  dtDate := value;
  while DayOfWeek(dtDate) <> 1 do
    dtDate := dtDate - 1;
  result := dtDate;
end;

class function tkitU.firstDOY(const value: tdate): tdateTime;
var
  lwdYear: word;
  lwdMonth: word;
  lwdDay: word;
begin
  if value = 0 then
    decodeDate(now, lwdYear, lwdMonth, lwdDay)
  else
    decodeDate(value, lwdYear, lwdMonth, lwdDay);

  result := (strtoDate(inttoStr(1) + '/' + inttoStr(1) + '/' + inttoStr(lwdYear)));
end;



class function tkitU.gmttoDateTime(const value: string): tdatetime;
var
  lstrValue: string;
begin
  result := 0;

  if value.trim = '' then
    exit;

  lstrValue := value;
  lstrValue := stringreplace(lstrValue, ' GMT', '', [rfReplaceAll]);
  lstrValue := stringreplace(lstrValue, 'GMT', '', [rfReplaceAll]);

  for var intCount := Low(cDaysOfWeekEn) to High(cDaysOfWeekEn) do
  begin
    lstrValue := stringreplace(lstrValue, cDaysOfWeekEn[intCount] + ', ', '', [rfReplaceAll]);
    lstrValue := stringreplace(lstrValue, cDaysOfWeekEn[intCount] + ' ', '', [rfReplaceAll]);
    lstrValue := stringreplace(lstrValue, cDaysOfWeekEn[intCount], '', [rfReplaceAll]);
  end;

  for var intCount := Low(cMonthsOfYearEn) to High(cMonthsOfYearEn) do
  begin
    lstrValue := stringreplace(lstrValue, ' ' + cMonthsOfYearEn[intCount] + ' ', '/' + intCount.ToString + '/', [rfReplaceAll]);
    lstrValue := stringreplace(lstrValue, cMonthsOfYearEn[intCount], '/' + intCount.ToString + '/', [rfReplaceAll]);
  end;

  try
    result := strtodatetime(lstrValue);
  except
  end;
end;

class function tkitU.strtoMemoryStream(value: string): tmemoryStream;
var
  lslloadParametro: tstringList;
begin
  result := tmemoryStream.create;

  lslloadParametro := tstringList.Create;
  lslloadParametro.add(value);
  lslloadParametro.savetostream(result);

  if lslloadParametro <> nil then
    FreeAndNil(lslloadParametro);

  Result.position := 0;
end;

class procedure tkitU.base64toMemoryStream(const value: string; var strmResultStream: tmemorystream);
begin
  if strmResultStream = nil then
    strmResultStream := tmemoryStream.Create
  else
    strmResultStream.Clear;

  try
    tiddecodermime.decodeStream(value, strmResultStream);
    strmResultStream.Position := 0;
  finally
  end;
end;

class function tkitU.bytetoMemoryStream(value: tbytes): tmemoryStream;
var
  strAux: tbytes;
begin
  Result := tmemoryStream.Create;

  strAux := value;
  result.writeBuffer(pointer(strAux)^, length(strAux));
  result.Position := 0;
end;

class function tkitU.iif(const condition: boolean; const trueValue, falseValue: variant): variant;
begin
  if condition then
    result := trueValue
  else
    result := falseValue;
end;

class function tkitU.isCelPhone(const value: string): boolean;
var
  lstrfoneCheck: string;
  lintpostCheck: integer;
begin
  lintpostCheck := 0;
  lstrfoneCheck := self.strtoChars(value, '0123456789');

  case Length(lstrfoneCheck) of
  08: lintpostCheck := 1;
  09: lintpostCheck := 2;
  10: lintpostCheck := 3;
  11: lintpostCheck := 4;
  end;

  result := (lintpostCheck > 0) and (self.strtoInt(lstrfoneCheck[lintpostCheck]) in [6..9]);
end;

class function tkitU.isCodPhone(const value: string): boolean;
var
  lstrfoneCheck: String;
  lintCount: Integer;
begin
  result := False;
  lstrfoneCheck := self.strtoChars(value, '0123456789');

  if length(lstrfoneCheck) in [10,11] then
  begin
    lstrfoneCheck := copy(lstrfoneCheck, 1, 2);
    for lintCount := 0 to length(cDDD) - 1 do
      if cDDD[lintCount] = lstrfoneCheck then
      begin
        result := True;
        break;
      end;
  end;
end;

class function tkitU.isDate(const value: String): boolean;
var
  lbooResult: boolean;
  ldtValue : tdate;
begin
  try
    ldtValue  := strtoDate(value);
    lbooResult := true;
  except
    lbooResult := false;
  end;

  result := lbooResult;
end;

class function tkitU.isDoc(const value: string): boolean;
var
  lstrDoc: string;
  ldocType: tdocType;
begin
  result := false;

  lstrDoc := strToChars(value);
  ldocType :=  iif(length(lstrDoc) = 11, dtssn, dtein);

  case ldocType of
  dtssn:
    begin
      var intn1, intn2, intn3, intn4, intn5, intn6, intn7, intn8, intn9: Integer;
      var intd1, intd2: Integer;
      var strSender, strCalc: string;

      lstrDoc := Copy('0000000000' + lstrDoc, Length('0000000000' + lstrDoc) - 10, 11);

      intn1 := strToInt(lstrDoc[1]);
      intn2 := strToInt(lstrDoc[2]);
      intn3 := strToInt(lstrDoc[3]);
      intn4 := strToInt(lstrDoc[4]);
      intn5 := strToInt(lstrDoc[5]);
      intn6 := strToInt(lstrDoc[6]);
      intn7 := strToInt(lstrDoc[7]);
      intn8 := strToInt(lstrDoc[8]);
      intn9 := strToInt(lstrDoc[9]);

      intd1 := intn9 * 2 + intn8 * 3 + intn7 * 4 + intn6 * 5 + intn5 * 6 + intn4 * 7 + intn3 * 8 + intn2 * 9 + intn1 * 10;
      intd1 := 11 - (intd1 mod 11);

      if intd1 >= 10 then
        intd1 := 0;

      intd2 := intd1 * 2 + intn9 * 3 + intn8 * 4 + intn7 * 5 + intn6 * 6 + intn5 * 7 + intn4 * 8 + intn3 * 9 + intn2 * 10 + intn1 * 11;
      intd2 := 11 - (intd2 mod 11);

      if intd2 >= 10 then
        intd2 := 0;

      strCalc := IntToStr(intd1) + IntToStr(intd2);
      strSender := lstrDoc[10] + lstrDoc[11];

      if strCalc = strSender then
        result := true
      else
        result := false;
    end;
  dtein:
    begin
      var intn1, intn2, intn3, intn4, intn5, intn6, intn7, intn8, intn9, intn10, intn11, intn12: Integer;
      var intd1, intd2: Integer;
      var strSender, strCalc: string;

      lstrDoc := Copy('00000000000000' + lstrDoc, Length('00000000000000' + lstrDoc) - 13, 14);

      intn1 := strToInt(lstrDoc[1]);
      intn2 := strToInt(lstrDoc[2]);
      intn3 := strToInt(lstrDoc[3]);
      intn4 := strToInt(lstrDoc[4]);
      intn5 := strToInt(lstrDoc[5]);
      intn6 := strToInt(lstrDoc[6]);
      intn7 := strToInt(lstrDoc[7]);
      intn8 := strToInt(lstrDoc[8]);
      intn9 := strToInt(lstrDoc[9]);
      intn10 := strToInt(lstrDoc[10]);
      intn11 := strToInt(lstrDoc[11]);
      intn12 := strToInt(lstrDoc[12]);

      intd1 := intn12 * 2 + intn11 * 3 + intn10 * 4 + intn9 * 5 + intn8 * 6 + intn7 * 7 + intn6 * 8 + intn5 * 9 + intn4 * 2 + intn3 * 3 + intn2 * 4 + intn1 * 5;
      intd1 := 11 - (intd1 mod 11);

      if intd1 >= 10 then
        intd1 := 0;

      intd2 := intd1 * 2 + intn12 * 3 + intn11 * 4 + intn10 * 5 + intn9 * 6 + intn8 * 7 + intn7 * 8 + intn6 * 9 + intn5 * 2 + intn4 * 3 + intn3 * 4 + intn2 * 5 + intn1 * 6;
      intd2 := 11 - (intd2 mod 11);

      if intd2 >= 10 then
        intd2 := 0;

      strCalc := IntToStr(intd1) + IntToStr(intd2);
      strSender := lstrDoc[13] + lstrDoc[14];

      if strCalc = strSender then
        result := True
      else
        result := False;
    end;
  end;
end;

class function tkitU.isInArray(const value: string; index: integer; const arrChars: array of char): boolean;
var
  lchValue: char;
begin
  lchValue := value[index];
  result := lchValue.IsInArray(arrChars);
end;

class function tkitU.isMail(const value: string): boolean;
var
  lintIndex: integer;
  lintCont: integer;
  lstrEmail: string;

const
  caraEsp: array [1 .. 40] of string = ('!', '#', '$', '%', '¨', '&', '*', '(', ')', '+', '=', '§', '¬', '¢', '¹', '²', '³', '£', '´', '`', 'ç', 'Ç', ',', ';', ':', '<', '>', '~', '^', '?', '/', '', '|', '[', ']', '{', '}', 'º', 'ª', '°');

begin
  lstrEmail := value;
  result := true;
  lintCont := 0;

  if lstrEmail <> '' then
    if (pos('@', lstrEmail) <> 0) and (pos('.', lstrEmail) <> 0) then // existe @ .
    begin
      if (pos('@', lstrEmail) = 1) or (pos('@', lstrEmail) = length(lstrEmail)) or (pos('.', lstrEmail) = 1) or (pos('.', lstrEmail) = length(lstrEmail)) or (pos(' ', lstrEmail) <> 0) then
        result := false
      else // @ seguido de . e vice-versa
        if (abs(pos('@', lstrEmail) - pos('.', lstrEmail)) = 1) then
          result := false
        else
        begin
          for lintIndex := 1 to 40 do // se existe Caracter Especial
            if pos(String(CaraEsp[lintIndex]), String(lstrEmail)) <> 0 then
              result := false;
          for lintIndex := 1 to length(lstrEmail) do
          begin // se existe apenas 1 @
            if lstrEmail[lintIndex] = '@' then
              lintCont := lintCont + 1; // . seguidos de .
            if (lstrEmail[lintIndex] = '.') and (lstrEmail[lintIndex + 1] = '.') then
              result := false;
          end;
          // . no false, 2ou+ @, . no i, - no i, _ no i
          if (lintCont >= 2) or (lstrEmail[length(lstrEmail)] = '.') or (lstrEmail[1] = '.') or (lstrEmail[1] = '_') or (lstrEmail[1] = '-') then
            result := false;
          // @ seguido de COM e vice-versa
          if (abs(pos('@', lstrEmail) - pos('com', lstrEmail)) = 1) then
            result := false;
          // @ seguido de - e vice-versa
          if (abs(pos('@', lstrEmail) - pos('-', lstrEmail)) = 1) then
            result := false;
          // @ seguido de _ e vice-versa
          if (abs(pos('@', lstrEmail) - pos('_', lstrEmail)) = 1) then
            result := false;
        end;
    end
    else
      result := false;
end;

class function tkitU.lastDOM(const value: tdate): tdateTime;
var
  lwdYear: word;
  lwdMonth: word;
  lwdDay: word;
begin
  if value = 0 then
    decodedate(now, lwdYear, lwdMonth, lwdDay)
  else
    decodedate(value, lwdYear, lwdMonth, lwdDay);

  lwdDay := 1;
  if lwdMonth = 12 then
  begin
    lwdMonth := 1;
    lwdYear := lwdYear + 1;
  end
  else
    lwdMonth := lwdMonth + 1;

  result := (strtoDate(inttoStr(lwdDay) + '/' + inttoStr(lwdMonth) + '/' + inttoStr(lwdYear)) - 1);
end;

class function tkitU.lastDOW(const value: tdate): tdateTime;
var
  ldtValue: tdate;
begin
  ldtValue := value;
  while dayofWeek(ldtValue) <> 7 do
    ldtValue := ldtValue + 1;
  result := ldtValue;
end;

class function tkitU.lastDOY(const value: tdate): tdateTime;
var
  ldwYear: word;
  lwdMonth: word;
  lwdDay: word;
begin
  if value = 0 then
    decodeDate(now, ldwYear, lwdMonth, lwdDay)
  else
    decodeDate(value, ldwYear, lwdMonth, lwdDay);

  result := (strtoDate(inttoStr(31) + '/' + inttoStr(12) + '/' + inttoStr(ldwYear)));
end;

class function tkitU.memoryStreamToBase64(const value: tmemorystream): string;
begin
  try
    value.position := 0;
    result := TIdEncoderMIME.EncodeStream(value);
  finally
  end;
end;

class function tkitU.notCharacter(const value: string; ext: boolean): string;
const
  //Lista de caracteres especiais
  xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                     'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                     'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                     'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
  //Lista de caracteres para troca
  xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E','i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
  //Lista de Caracteres Extras
  xCarExt: array[1..49] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                     '(',')','_','+','=','{','}','[',']','?',
                                     ';',':',',','|','*','"','~','^','´','`',
                                     '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                     '®','½','¼','ß','µ','þ','ý','Ý','-');
var
  lstrText: string;
  lintCount: Integer;
begin
   lstrText := value;
   for lintCount:=1 to 38 do
     lstrText := stringReplace(lstrText, xCarEsp[lintCount], xCarTro[lintCount], [rfreplaceall]);

   //De acordo com o parâmetro aLimExt, elimina caracteres extras.
   if (ext) then
     for lintCount:=1 to 49 do
       lstrText := stringReplace(lstrText, xCarExt[lintCount], '', [rfreplaceall]);

   result := lstrText;
end;

class function tkitU.readFloat(value: string; offSet: Integer): single;
var
  lslValue: tstringList;
begin
  lslValue := nil;
  try
    lslValue := tstringList.create;
    lslValue.commaText := value;

    if offSet > lslValue.count - 1 then
      result := 0
    else
      result := tkitU.strToFloat(lslValue[offSet]);
  finally
    if lslValue <> nil then
      freeandnil(lslValue);
  end;
end;

class function tkitU.readInt(value: string; offSet: integer): integer;
var
  lslValue: tstringList;
begin
  lslValue := nil;
  try
    lslValue := tstringList.create;
    lslValue.commaText := value;

    if offSet > lslValue.count - 1 then
      result := 0
    else
      result := tkitU.strToInt(lslValue[offSet]);
  finally
    if lslValue <> nil then
      freeandnil(lslValue);
  end;
end;

class function tkitU.readStr(value: string; offSet: integer): string;
var
  lslValue: tstringList;
begin
  lslValue := nil;
  try
    lslValue := tstringList.create;
    lslValue.commaText := value;

    if offSet > lslValue.count - 1 then
      result := ''
    else
      result := lslValue[offSet];
  finally
    if lslValue <> nil then
      freeandnil(lslValue);
  end;
end;

class function tkitU.secondsBetween(const pdtStart, pdtEnd: tdateTime): Int64;
var
  ptsTempStart: ttimeStamp;
  ptsTempEnd: ttimeStamp;
begin
  ptsTempStart := datetimeToTimeStamp(pDtStart);
  ptsTempEnd   := datetimeToTimeStamp(pdtEnd);

  result := Trunc((((((ptsTempEnd.Date - ptsTempStart.Date) * 24) * 60) * 60) * 100) +
                    (ptsTempEnd.Time - ptsTempStart.Time) / 1000);
end;

{$ifdef securit_cript_lockbox}
  class function tkitU.ssc(value, key: string): string;
  var
    cipher: tlbblowfish;
  begin
    cipher := nil;

    try
      result := '';

      if Trim(value) <> '' then
      begin
        cipher := tlbblowfish.create(nil);
        cipher.generatekey(key);

        result := string(cipher.encryptString(value));
      end
      else
        result := '';

    finally
      if cipher <> nil then
        FreeAndNil(cipher);
    end;
  end;

  class function tkitU.ssd(value, key: String): String;
  var
    cipher: tlbblowfish;
  begin
    cipher := nil;

    try
      result := '';

      if Trim(value) <> '' then
      begin
        cipher := tlbblowfish.Create(nil);
        cipher.generatekey(key);

        result := String(cipher.decryptstring(value));
      end
      else
        result := '';

    finally
      if cipher <> nil then
        FreeAndNil(cipher);
    end;
  end;
{$endif}

class function tkitU.strToChars(const value: string; chars: string): string;
var
  lintCount: Integer;
begin
  result := '';
  for lintCount := low(value) to high(value) do
    if Pos(value[lintCount], Chars) > 0 then
      result := result + value[lintCount];
end;

class function tkitU.strToFloat(const value: string): single;
var
  lintCount: integer;
  lstrResult: string;
  lbooComma: boolean;
  lbooNegative: boolean;
begin
  lbooComma := false;
  lbooNegative := false;

  for lintCount := low(value) to high(value) do
  begin
    if self.isInArray(value, lintCount, ccharFloat) or (value[lintCount] = formatSettings.decimalSeparator)  then
      if value[lintCount] = '-' then
        lbooNegative := True
      else
        if ((value[lintCount] = formatSettings.decimalSeparator) and (lbooComma = false)) or (value[lintCount] <> formatSettings.decimalSeparator) then
        begin
          lstrResult := lstrResult + value[lintCount];
          if value[lintCount] = formatSettings.decimalSeparator then
            lbooComma := true;
        end;
  end;

  if lstrResult = '' then
    result := 0
  else
    if lbooNegative then
      result := - system.sysutils.strtoFloat(lstrResult)
    else
      result := system.sysutils.strToFloat(lstrResult);
end;

class function tkitU.strToInt(const value: string): integer;

  function idInteger(value: string): boolean;
  var
    lstrTemp: string;
    lbooNegative: boolean;
    limp1: integer;
    limp2: integer;
  begin
    // Verifica se um texto pode ser convertido em um inteiro, levando em consideração
    // os limites negativos e positivos de um inteiro (-2147483648 .. 2147483647)
    lstrTemp := stringReplace(value, '-', '', [rfReplaceAll]);
    if (Length(lstrTemp) = 10) then
    begin
      result := true;
      lbooNegative := false;

      if value[1] = '-' then
        lbooNegative := true;

      limp1 := 21474;
      if lbooNegative then
        limp2 := 83648
      else
        limp2 := 83647;

      lstrTemp := copy(lstrTemp, 1, 10);
      if (strToInt(copy(lstrTemp, 1, 5)) > limp1) or ((strToInt(copy(lstrTemp, 1, 5)) = limp1) and (strToInt(copy(lstrTemp, 6, 5)) > limp2)) then
        result := false;
    end
    else
      if (length(lstrTemp) > 10) then
        result := false
      else
        result := true;
  end;

var
  lintCount: integer;
  lstText: string;
  lstrResult: string;
  lbooNegative: boolean;

begin
  lstText := value;
  lbooNegative := true;

  for lintCount := low(lstText) to High(lstText) do
  begin
    if isInArray(lstText, lintCount, cCharInteger) or (isInArray(lstText, lintCount, ['-']) and lbooNegative) then
    begin
      lstrResult := lstrResult + lstText[lintCount];
      lbooNegative := False;
    end;
  end;

  if (lstrResult = '') or (lstrResult = '-') or (not idInteger(lstrResult)) then
    result := 0
  else
  begin
    if Trim(lstrResult) <> '' then
      result := system.sysutils.strToInt(lstrResult)
    else
      result := 0;
  end;
end;

class function tkitU.strToStrNumber(const value: string): string;
var
 lintCount: integer;
 lstrText: string;
 lstrResult: string;
begin
  result := '';

  lstrText := value;
  for lintCount := 1 to length(lstrText) do
    if isInArray(lstrText, lintCount, cCharFloat) then
      lstrResult := lstrResult + lstrText[lintCount];

  result := lstrResult;
  if result = '' then
    result := '0';
end;

class function tkitU.textFormat(const value: String; Tipo: tformatType; IeUF: String): string;
var
  lstrLoad: String;
  lstrResult: String;
  lintCount: Integer;
  LwrdDay: Word;
  LwrdMonth: Word;
  LwrdYear: Word;
  LwrdDayInc: Word;
  LwrdMonthInc: Word;
  LwrdYearInc: Word;
  LslLoad: TStringList;
  LDate: TDate;

  function IEmask(AValue : String; UF : String) : String;
  var
   LenDoc : Integer;
   mask : String;

  begin
    UF      := UpperCase( UF ) ;
    LenDoc  := Length( AValue ) ;
    mask := StringOfChar('*', LenDoc) ;

    IF UF = 'AC' Then mask := '**.***.***/***-**';
    IF UF = 'AL' Then mask := '*********';
    IF UF = 'AP' Then mask := '*********';
    IF UF = 'AM' Then mask := '**.***.***-*';
    IF UF = 'BA' Then mask := '*******-**';
    IF UF = 'CE' Then mask := '********-*';
    IF UF = 'DF' Then mask := '***********-**';
    IF UF = 'ES' Then mask := '*********';
    IF UF = 'GO' Then mask := '**.***.***-*';
    IF UF = 'MA' Then mask := '*********';
    IF UF = 'MT' Then mask := '**********-*';
    IF UF = 'MS' Then mask := '**.***.***-*';
    IF UF = 'MG' Then mask := '***.***.***/****';
    IF UF = 'PA' Then mask := '**-******-*';
    IF UF = 'PB' Then mask := '********-*';
    IF UF = 'PR' Then mask := '***.*****-**';
    IF UF = 'PE' Then mask := Iif((LenDoc>9),'**.*.***.*******-*','*******-**');
    IF UF = 'PI' Then mask := '*********';
    IF UF = 'RJ' Then mask := '**.***.**-*';
    IF UF = 'RN' Then mask := Iif((LenDoc>9),'**.*.***.***-*','**.***.***-*');
    IF UF = 'RS' Then mask := '***/*******';
    IF UF = 'RO' Then mask := Iif((LenDoc>13),'*************-*','***.*****-*');
    IF UF = 'RR' Then mask := '********-*';
    IF UF = 'SC' Then mask := '***.***.***';
    IF UF = 'SP' Then mask := Iif((LenDoc>1) and (AValue[1]='P'),'*-********.*/***', '***.***.***.***');
    IF UF = 'SE' Then mask := '**.***.***-*';
    IF UF = 'TO' Then mask := Iif((LenDoc=11),'**.**.******-*','**.***.***-*');

    Result := mask;
  end;

  function numericMask(ANumValue, mask: String): String;
  var
    LenMas, LenDoc: Integer;
    I, J: Integer;
    C: Char;
  begin
    Result := '';
    ANumValue := Trim( ANumValue );
    LenMas := Length( mask ) ;
    LenDoc := Length( ANumValue );

    J := LenMas ;
    For I := LenMas downto 1 do
    begin
      C := mask[I] ;

      if C = '*' then
      begin
        if J <= ( LenMas - LenDoc ) then
          C := '0'
        else
          C := ANumValue[( J - ( LenMas - LenDoc ) )] ;

        Dec( J ) ;
      end;

      Result := C + Result;
    end;
  end;

begin
  LslLoad := nil;
  Result := '';

  try
    try
      case Tipo of
        tcep:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];
              if Length(lstrResult)= 3 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,1)  else
              if Length(lstrResult)= 4 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,2)  else
              if Length(lstrResult)= 5 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3)  else
              if Length(lstrResult)= 6 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '-' + copy(lstrResult,6,1) else
              if Length(lstrResult)= 7 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '-' + copy(lstrResult,6,2) else
              if Length(lstrResult)= 8 then
                    Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '-' + copy(lstrResult,6,3) else
              Result := lstrResult;
          except
            result := '';
          end;
        end;
        tphone:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];
              if Length(lstrResult)= 1 then
                Result := '(' + copy(lstrResult,1,1) else
              if Length(lstrResult)= 2 then
                Result := '(' + copy(lstrResult,1,2) else
              if Length(lstrResult)= 3 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,1) else
              if Length(lstrResult)= 4 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,2) else
              if Length(lstrResult)= 5 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,3) else
              if Length(lstrResult)= 6 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,4) else
              if Length(lstrResult)= 7 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,5) else
              if Length(lstrResult)= 8 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,5) + '-' + copy(lstrResult,8,1)  else
              if Length(lstrResult)= 9 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,5) + '-' + copy(lstrResult,8,2)  else
              if Length(lstrResult)= 10 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,5) + '-' + copy(lstrResult,8,3)  else
              if Length(lstrResult)= 11 then
                Result := '(' + copy(lstrResult,1,2) + ') ' + copy(lstrResult,3,5) + '-' + copy(lstrResult,8,4)  else
              Result := lstrResult;
          except
          result := '';
          end;
        end;
        tCpf:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];
            if Length(lstrResult)= 4 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,1) else
            if Length(lstrResult)= 5 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,2) else
            if Length(lstrResult)= 6 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) else
            if Length(lstrResult)= 7 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) + '.' + copy(lstrResult,7,1) else
            if Length(lstrResult)= 8 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) + '.' + copy(lstrResult,7,2) else
            if Length(lstrResult)= 9 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) + '.' + copy(lstrResult,7,3) else
            if Length(lstrResult)= 10 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) + '.' + copy(lstrResult,7,3) + '-' + copy(lstrResult,10,1) else
            if Length(lstrResult)= 11 then
                Result := copy(lstrResult,1,3) + '.' + copy(lstrResult,4,3) + '.' + copy(lstrResult,7,3) + '-' + copy(lstrResult,10,2) else

            Result := lstrResult;
          except
            result := '';
          end;
        end;
        tCnpj:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];
              if Length(lstrResult)= 4 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,2) else
              if Length(lstrResult)= 5 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) else
              if Length(lstrResult)= 6 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,1) else
              if Length(lstrResult)= 7 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,2) else
              if Length(lstrResult)= 8 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) else
              if Length(lstrResult)= 9 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,1) else
              if Length(lstrResult)= 10 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,2) else
              if Length(lstrResult)= 11 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,3) else
              if Length(lstrResult)= 12 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,4) else
              if Length(lstrResult)= 13 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,4) + '.' + copy(lstrResult,13,1) else
              if Length(lstrResult)= 14 then
                Result := copy(lstrResult,1,2) + '.' + copy(lstrResult,3,3) + '.' + copy(lstrResult,6,3) + '/' + copy(lstrResult,9,4) + '-' + copy(lstrResult,13,2) else
              Result := lstrResult;
          except
            result := '';
          end;
        end;
        tvalidateCredcard:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];
            if Length(lstrResult)= 3 then
              Result := copy(lstrResult,1,2) + '/' + copy(lstrResult,3,1) else
            if Length(lstrResult)= 4 then
              Result := copy(lstrResult,1,2) + '/' + copy(lstrResult,3,1) + '' + copy(lstrResult,4,1)  else
            Result := lstrResult;
          except
            result := '';
          end;
        end;
        tCredCard:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];

            if Length(lstrResult)= 5 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,1) else
            if Length(lstrResult)= 6 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,2) else
            if Length(lstrResult)= 7 then
              Result := copy(lstrResult,1,4) + '' + copy(lstrResult,5,3) else
            if Length(lstrResult)= 8 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) else
            if Length(lstrResult)= 9 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,1) else
            if Length(lstrResult)= 10 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,2) else
            if Length(lstrResult)= 11 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,3) else
            if Length(lstrResult)= 12 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,4) else
            if Length(lstrResult)= 13 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,4) + ' ' + copy(lstrResult,13,1) else
            if Length(lstrResult)= 14 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,4) + ' ' + copy(lstrResult,13,2) else
            if Length(lstrResult)= 15 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,4) + ' ' + copy(lstrResult,13,3) else
            if Length(lstrResult)= 16 then
              Result := copy(lstrResult,1,4) + ' ' + copy(lstrResult,5,4) + ' ' + copy(lstrResult,9,4) + ' ' + copy(lstrResult,13,4) else
            Result := lstrResult;
          except
            result := '';
          end;
        end;

        tfcep:
        begin
          try
            lstrResult := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrResult := lstrResult + value[lintCount];

            if Length(lstrResult)= 5 then
              Result := copy(lstrResult,1,2)+'.'+copy(lstrResult,3,3) else
            if Length(lstrResult)= 6 then
              Result := copy(lstrResult,1,3)+'.'+copy(lstrResult,4,3) else
            if Length(lstrResult)= 7 then
              Result := copy(lstrResult,1,2)+'.'+copy(lstrResult,3,3)+'-'+copy(lstrResult,6,2)+'0' else
            if Length(lstrResult)= 8 then
              Result := copy(lstrResult,1,2)+'.'+copy(lstrResult,3,3)+'-'+copy(lstrResult,6,3) else
            if Length(lstrResult)= 9 then
              Result := copy(lstrResult,1,3)+'.'+copy(lstrResult,4,3)+'-'+copy(lstrResult,7,3) else
            Result := lstrResult;
          except
            Result := '';
          end;
        end;

        tfPostCode:
          begin
            if value = '0' then
              Exit;

            lstrLoad := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrLoad := lstrLoad + value[lintCount];

            if Length(lstrLoad) = 5 then
              Result := Copy(lstrLoad, 1, 2) + '.' + Copy(lstrLoad, 3, 3)
            else if Length(lstrLoad) = 6 then
              Result := Copy(lstrLoad, 1, 3) + '.' + Copy(lstrLoad, 4, 3)
            else if Length(lstrLoad) = 7 then
              Result := Copy(lstrLoad, 1, 2) + '.' + Copy(lstrLoad, 3, 3) + '-' + Copy(lstrLoad, 6, 2) + '0'
            else if Length(lstrLoad) = 8 then
              Result := Copy(lstrLoad, 1, 2) + '.' + Copy(lstrLoad, 3, 3) + '-' + Copy(lstrLoad, 6, 3)
            else if Length(lstrLoad) = 9 then
              Result := Copy(lstrLoad, 1, 3) + '.' + Copy(lstrLoad, 4, 3) + '-' + Copy(lstrLoad, 7, 3)
            else
              Result := lstrLoad;
          end;
        tfDoc:
          begin
            Result := '';
            lstrLoad := value;

            if not(self.strToFloat(lstrLoad) > 0) then
              Exit;

            for lintCount := Low(lstrLoad) to High(lstrLoad) do
              if isInArray(lstrLoad, lintCount, cCharInteger) then
                lstrResult := lstrResult + lstrLoad[lintCount];

            //while Length(lstrResult) < 11 do
              //lstrResult := '0' + lstrResult;

           if isDoc(lstrResult) then
            begin
              Result := Copy(lstrResult, 1, 3) + '.' + Copy(lstrResult, 4, 3) + '.' + Copy(lstrResult, 7, 3) + '-' + Copy(lstrResult, 10, 2);
              Exit;
            end;

            //while Length(lstrResult) < 14 do
              //lstrResult := '0' + lstrResult;

            if isDoc(lstrResult) then
            begin
              Result := Copy(lstrResult, 1, 2) + '.' + Copy(lstrResult, 3, 3) + '.' + Copy(lstrResult, 6, 3) + '/' + Copy(lstrResult, 9, 4) + '-' + Copy(lstrResult, 13, 2);
              Exit;
            end;

            Result := lstrResult;
          end;
        tfFoneNumber:
          begin
            if (Length(value) > 0) and (value[1] = '0') then
            begin
              Result := value;
              Exit;
            end;

            lstrLoad := '';
            for lintCount := Low(value) to High(value) do
              if isInArray(value, lintCount, cCharInteger) then
                lstrLoad := lstrLoad + value[lintCount];

            if Length(lstrLoad) = 7 then
              Result := Copy(lstrLoad, 1, 3) + '-' + Copy(lstrLoad, 4, 4)
            else if Length(lstrLoad) = 8 then
              Result := Copy(lstrLoad, 1, 4) + '-' + Copy(lstrLoad, 5, 4)
            else if Length(lstrLoad) = 9 then
              if Copy(lstrLoad, 1, 1) <> '9' then
                Result := '(' + Copy(lstrLoad, 1, 2) + ') ' + Copy(lstrLoad, 3, 3) + '-' + Copy(lstrLoad, 6, 4)
              else
                Result := Copy(lstrLoad, 1, 5) + '-' + Copy(lstrLoad, 6, 4)
            else if Length(lstrLoad) = 10 then
              Result := '(' + Copy(lstrLoad, 1, 2) + ') ' + Copy(lstrLoad, 3, 4) + '-' + Copy(lstrLoad, 7, 4)
            else if Length(lstrLoad) = 11 then
              Result := '(' + Copy(lstrLoad, 1, 2) + ') ' + Copy(lstrLoad, 3, 5) + '-' + Copy(lstrLoad, 8, 4)
            else if Length(lstrLoad) = 13 then
              Result := '+' + Copy(lstrLoad, 1, 2) + ' (' + Copy(lstrLoad, 3, 2) + ') ' + Copy(lstrLoad, 5, 5) + '-' + Copy(lstrLoad, 10, 4)
            else
              Result := lstrLoad;
          end;
        tfDate:
          begin
            LslLoad := TStringList.Create;
            LslLoad.CommaText := StringReplace(value, '/', ',', [rfReplaceAll]);

            if LslLoad.Count > 0 then
              LwrdDay := self.strToInt(LslLoad[0])
            else
              LwrdDay := 0;
            if LslLoad.Count > 1 then
              LwrdMonth := self.strToInt(LslLoad[1])
            else
              LwrdMonth := 0;
            if LslLoad.Count > 2 then
              LwrdYear := self.strToInt(LslLoad[2])
            else
              LwrdYear := 0;
            if (LwrdDay = 0) or (LwrdMonth = 0) or (LwrdYear = 0) or (LwrdDay > 31) or (LwrdMonth > 12) or (LwrdYear < 1900) then
              Result := FormatDateTime('dd/MM/yyyy', Date)
            else
            begin
              try
                Result := FormatDateTime('dd/MM/yyyy', EncodeDate(LwrdYear, LwrdMonth, LwrdDay));
              except
                if (LwrdMonth = 2) and (LwrdDay > 28) then
                  LwrdDay := 28
                else if LwrdDay = 31 then
                  LwrdDay := 30;
                Result := FormatDateTime('dd/MM/yyyy', EncodeDate(LwrdYear, LwrdMonth, LwrdDay));
              end;
            end;
          end;
        tfAge:
          begin
            LDate := StrToDate(value);

            if (LDate >= Date) or (LDate < IncMonth(Date, -1800)) then
              Exit;

            DecodeDate(LDate, LwrdYear, LwrdMonth, LwrdDay);
            DecodeDate(Date, LwrdYearInc, LwrdMonthInc, LwrdDayInc);

            LwrdMonth := LwrdMonth + LwrdYear * 12;
            LwrdMonthInc := LwrdMonthInc + LwrdYearInc * 12;
            LwrdYear := (LwrdMonthInc - LwrdMonth) div 12;
            LwrdMonth := (LwrdMonthInc - LwrdMonth) - 12 * LwrdYear;

            lstrLoad := IntToStr(LwrdYear) + ' anos';
            lstrLoad := lstrLoad + ', ' + IntToStr(LwrdMonth) + ' meses';

            Result := lstrLoad;
          end;
          tfIE:
            Result :=  numericMask(value,IEmask(value, IeUF));
      end;
    except
      raise;
    end;
  finally
    if LslLoad <> nil then
      FreeAndNil(LslLoad);
  end;
end;

class function tkitU.timeintervalToStr(interval: Int64): String;
var
  lwdCount: word;
  lstrDesc: string;
  lbooStart: boolean;
  lint64Values: array[1..6] of Int64;
const
  descs: array[1..6] of string=('Mês',' Semana','Dia','Hora','Minuto','Segundo');

begin
   result:='';

   lint64Values[1] :=trunc(interval/(31 * 24 * 3600));
   interval := interval - (lint64Values[1] * (31 * 24 * 3600));

   lint64Values[2] := trunc(interval/(7 * 24 * 3600));
   interval := interval - (lint64Values[2] * (7 * 24 * 3600));

   lint64Values[3] := trunc(interval/(24 * 3600));
   interval := interval - (lint64Values[3] * (24 * 3600));

   lint64Values[4] := trunc(interval/3600);
   interval := interval - (lint64Values[4] * 3600);

   lint64Values[5] := trunc(interval/60);
   interval := interval - (lint64Values[5] * 60);

   lint64Values[6]:= interval;
   lbooStart := false;

   for lwdCount := 1 to high(lint64Values) do
   begin

      if (lint64Values[lwdCount] <> 1) then
         lstrDesc := descs[lwdCount] + 's'
      else
         lstrDesc := descs[lwdCount];

      if (not lbooStart) and (lint64Values[lwdCount] = 0) then
         Continue
      else
         lbooStart := true;

      if (lwdCount < high(lint64Values)) then
         result := result + intToStr(lint64Values[lwdCount]) + ' ' + lstrDesc + ', '
      else
         result := result + inttoStr(lint64Values[lwdCount]) + ' ' + lstrDesc;
   end;
end;

class function tkitU.uuId(const onlyNumbers: boolean): string;
var
  lgidID: TGuid;
  lgidIDResult  : HResult;
begin
  lgidIDResult := CreateGuid(lgidID);

  if lgidIDResult = S_OK then
  begin
    result := guidtoString(lgidID);

    if onlyNumbers then
    begin
      result := stringreplace(result, '{', '', [rfReplaceAll]);
      result := stringreplace(result, '}', '', [rfReplaceAll]);
    end;
  end;
end;

class function tkitU.isCredtCard(const value: string): integer;
var
  xCartao: string[21];
  VetCartao: array[0..21] of Byte absolute xCartao;
  kCartao: Integer;
  Cstr: string[21];
  y, x: Integer;
begin
  Cstr := '';
  FillChar(VetCartao, 22, #0);
  xCartao := value;

  for x := 1 to 20 do
  if (VetCartao[x] in [48..57]) then
    Cstr := Cstr + chr(VetCartao[x]);

  xCartao := '';
  xCartao := Cstr;
  kCartao := 0;

  if not odd(Length(xCartao)) then
    for x := (Length(xCartao) - 1) downto 1 do
    begin
      if odd(x) then
        y := ((VetCartao[x] - 48) * 2)
      else
        y := (VetCartao[x] - 48);
      if (y >= 10) then
        y := ((y - 10) + 1);

      kCartao := (kCartao + y)

    end
  else
  for x := (Length(xCartao) - 1) downto 1 do
  begin
    if odd(x) then
      y := (VetCartao[x] - 48)
    else
      y := ((VetCartao[x] - 48) * 2);
    if (y >= 10) then
      y := ((y - 10) + 1);

    kCartao := (kCartao + y)
  end;

  x := (10 - (kCartao mod 10));

  if (x = 10) then

  x := 0;

  if (x = (VetCartao[Length(xCartao)] - 48)) then
    Result := Ord(Cstr[1]) - Ord('2')
  else
    Result := 0
end;

class function tkitU.writeStrings(value: String; offSet: Integer; newValue: string): string;
var
  lslValue: tstringList;
  lintCount: Integer;
begin
  result := '';
  lslValue := nil;

  try
    lslValue := TStringList.Create;
    lslValue.CommaText := value;

    for lintCount := 0 to lslValue.Count - 1 do
    begin
      if lintCount > 0 then
        result := result + ',';

      if lintCount = offSet then
        result := result + '"' + newValue + '"'
      else
        result := result + '"' + lslValue[lintCount] + '"';
    end;

  finally
    if lslValue <> nil then
      freeandnil(lslValue);
  end;
end;

end.
