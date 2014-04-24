/*
Canavar.toro
26 Temmuz 2012 15:50 Arma filtre
*/

DEFINE TEMP-TABLE FasonGelis
    FIELD IsEmriNo AS CHARACTER FORMAT "X(60)":U
    FIELD OperasyonKod AS CHARACTER FORMAT "X(60)":U
    FIELD MalzemeKod AS CHARACTER FORMAT "X(60)":U
    FIELD PartiKod AS CHARACTER FORMAT "X(60)":U
    FIELD Miktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD Tamamlandi AS LOGICAL.

DEFINE VARIABLE xFirmaKod  AS CHARACTER INITIAL "ARMA2011".
DEFINE VARIABLE xUserKod  AS CHARACTER INITIAL "uroot".
DEFINE VARIABLE xDepoKod  AS CHARACTER INITIAL "A04100".
DEFINE VARIABLE xIstasyonKod  AS CHARACTER INITIAL "Z99185093".
DEFINE VARIABLE xBelgeTarih  AS CHARACTER INITIAL "18.12.2013".
DEFINE VARIABLE xHareketKod AS CHARACTER INITIAL "IR-181".
DEFINE VARIABLE xBelgeNo AS CHARACTER INITIAL "sanane". 

DEFINE VARIABLE MasterNo AS DECIMAL INITIAL 0.
DEFINE VARIABLE DetaySatir AS INTEGER INITIAL 0.
DEFINE VARIABLE IslemSonucu AS CHARACTER INITIAL "".

CREATE FasonGelis.
ASSIGN
    FasonGelis.IsEmriNo = "NC-011526"
    FasonGelis.OperasyonKod = "10"
    FasonGelis.MalzemeKod = "101201 AU 0002350"
    FasonGelis.PartiKod = "KSK0000568206"
    FasonGelis.Miktar = 5
    FasonGelis.Tamamlandi = FALSE.
RELEASE FasonGelis.

{Include3\Baglanti.i}

RUN C:\OpenEdge\BarsetProxy\Prosedurler\FasonDonus_run.p (INPUT xFirmaKod, INPUT xUserKod, INPUT xDepoKod, INPUT xIstasyonKod, INPUT xBelgeTarih, INPUT xHareketKod, INPUT xBelgeNo,
                    INPUT TABLE FasonGelis, OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).


MESSAGE "naber LAN" VIEW-AS ALERT-BOX INFO TITLE "OK mu?".
