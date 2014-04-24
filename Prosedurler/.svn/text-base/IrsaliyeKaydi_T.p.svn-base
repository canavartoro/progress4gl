

DEF TEMP-TABLE xIrsaliyeDetay         
            FIELD StokKodu AS CHARACTER
            FIELD Birim AS CHARACTER FORMAT "X(10)"
            FIELD Miktar AS DECIMAL
            FIELD DepoKod AS CHARACTER.


DEFINE VARIABLE FirmaKod     AS CHARACTER NO-UNDO INITIAL "ARMA2011".
DEFINE VARIABLE KullaniciKod AS CHARACTER NO-UNDO INITIAL "uroot".
DEFINE VARIABLE KayitId      AS INTEGER   NO-UNDO INITIAL 1011.
DEFINE VARIABLE BelgeNo      AS CHARACTER NO-UNDO INITIAL "test123".
DEFINE VARIABLE BelgeTarih   AS CHARACTER NO-UNDO INITIAL "22/01/2014".
DEFINE VARIABLE HareketKod   AS CHARACTER NO-UNDO INITIAL "IR-411".
DEFINE VARIABLE DigerDepo    AS CHARACTER NO-UNDO INITIAL "".
DEFINE VARIABLE CariKod      AS CHARACTER NO-UNDO INITIAL "120 00 00 0004".
DEFINE VARIABLE Aciklama     AS CHARACTER NO-UNDO INITIAL "deneme".
DEFINE VARIABLE AdresKod     AS CHARACTER NO-UNDO INITIAL "".

DEFINE VARIABLE MasterNo AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE DetaySatir AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE IslemSonucu AS CHARACTER NO-UNDO INITIAL "".

{Include3\Baglanti.i}

CREATE xIrsaliyeDetay.
ASSIGN 
    xIrsaliyeDetay.StokKodu = "101502 AU 0000076"
    xIrsaliyeDetay.Birim = "ad"
    xIrsaliyeDetay.Miktar = 1
    xIrsaliyeDetay.DepoKod = "A12300".
RELEASE xIrsaliyeDetay.


RUN C:\OpenEdge\BarsetProxy\Prosedurler\IrsaliyeKaydi_run.p (INPUT FirmaKod, INPUT KullaniciKod, INPUT KayitId,
                         INPUT BelgeNo, INPUT BelgeTarih, INPUT HareketKod,INPUT DigerDepo, INPUT CariKod, INPUT Aciklama, INPUT AdresKod,
                         INPUT TABLE xIrsaliyeDetay, OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).


