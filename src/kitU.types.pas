unit kitU.types;

interface

type
  tformatType = (tfpostCode, tfdoc, tffoneNumber, tfdate, tfAge, tfIE, tfcep, tCredCard, tvalidateCredcard, tCpf, tCnpj, tphone, tcep);
  tageType = (tiyears, tiyearsMonth, tiyearsMonthDay, tiresume, tifull, timonths);
  tdocType = (dtssn, dtein);

  tgeoCoordinate = record
    latitude: double;
    longitude: double;
  end;

implementation

{ tgeoCoordinate }

//constructor tgeoCoordinate.create(const platitude, plongitude: double);
//begin
//  latitude := platitude;
//  longitude := plongitude;
//end;

end.
