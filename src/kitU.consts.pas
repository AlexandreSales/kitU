unit kitU.consts;

interface

const
  cDaysOfWeekBr: array [1 .. 7] of string = ('Domingo','Segunda-feira','Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sábado');
  cDaysOfWeekEn: array [1 .. 7] of string = ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');

  cMonthsOfYearBr: array [1 .. 12] of string = ('Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
  cMonthsOfYearEn: array [1 .. 12] of string = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

  cDDD : array [0..43] of String = ('11','19',
                                    '21','24','27','28',
                                    '31','38',
                                    '41','46','47','49',
                                    '51','55',
                                    '67','61','62','63','64','65','66','68','69',
                                    '71','75','79',
                                    '81','82','83','84','85','86','87','88','89',
                                    '91','92','93','94','95','96','97','98','99');

  cCharInteger: array[0..9] of char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  cCharFloat: array[0..10] of char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-');

implementation

end.
