
ON FIND OF erp_detay2  OVERRIDE DO: END.
ON FIND OF erp_durustip  OVERRIDE DO: END.
ON FIND OF erp_master  OVERRIDE DO: END.
ON FIND OF erp_detay  OVERRIDE DO: END.
ON FIND OF isemri_tip  OVERRIDE DO: END.
ON WRITE OF erp_durus  OVERRIDE DO: END.
ON WRITE OF ham_detay  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}

DEFINE TEMP-TABLE Malzemeler
    FIELD Alternatif AS LOGICAL 
    FIELD DepoKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod2 AS CHARACTER FORMAT "X(30)"
    FIELD Birim AS CHARACTER FORMAT "X(10)"
    FIELD KMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD FMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)"
    FIELD MiktarSekli AS INTEGER.

DEFINE VARIABLE i-masterno AS RECID INITIAL 816821228.

CREATE Malzemeler.
ASSIGN
    Malzemeler.Alternatif = FALSE
    Malzemeler.DepoKod = "A01100"
    Malzemeler.MalzemeKod = "515000 AS 0000159"
    Malzemeler.MalzemeKod2 = "515000 AS 0000159"
    Malzemeler.Birim = "ad"
    Malzemeler.KMiktar = 15
    Malzemeler.FMiktar = 0
    Malzemeler.PartiNo = "KSK0007232545"
    Malzemeler.MiktarSekli = 1.
RELEASE Malzemeler.

CREATE Malzemeler.
ASSIGN
    Malzemeler.Alternatif = FALSE
    Malzemeler.DepoKod = "A01100"
    Malzemeler.MalzemeKod = "515000 AS 0000159"
    Malzemeler.MalzemeKod2 = "515000 AS 0000159"
    Malzemeler.Birim = "ad"
    Malzemeler.KMiktar = 10
    Malzemeler.FMiktar = 0
    Malzemeler.PartiNo = "KSK0007232545"
    Malzemeler.MiktarSekli = 1.
RELEASE Malzemeler.

CREATE Malzemeler.
ASSIGN
    Malzemeler.Alternatif = FALSE
    Malzemeler.DepoKod = "A01100"
    Malzemeler.MalzemeKod = "515000 AS 0000159"
    Malzemeler.MalzemeKod2 = "515000 AS 0000159"
    Malzemeler.Birim = "ad"
    Malzemeler.KMiktar = 5
    Malzemeler.FMiktar = 0
    Malzemeler.PartiNo = "KSK0007232545"
    Malzemeler.MiktarSekli = 1.
RELEASE Malzemeler.

ASSIGN firma-kod = "ARMA2011".
ASSIGN user-kod = "uroot".

OUTPUT TO VALUE("C:\OpenEdge\BarsetProxy\proc\deneme.txt").

RUN C:\OpenEdge\BarsetProxy\proc\UretimMalzemeleri.p (INPUT i-masterno, INPUT TABLE Malzemeler).

OUTPUT CLOSE.

MESSAGE "Tamam"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


ON FIND OF erp_detay2  REVERT.
ON FIND OF erp_durustip  REVERT.
ON FIND OF erp_master  REVERT.
ON FIND OF erp_detay  REVERT.
ON FIND OF isemri_tip  REVERT.
ON WRITE OF erp_durus  REVERT.
ON WRITE OF ham_detay  REVERT.
