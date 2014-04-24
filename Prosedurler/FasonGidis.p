/*
Canavar.toro
26 Temmuz 2012 15:50 Arma filtre
*/


DEFINE TEMP-TABLE FasonGidis
    FIELD MalzemeKod AS CHARACTER FORMAT "X(60)"
    FIELD Miktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)".    

DEFINE INPUT PARAMETER xFirmaKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xUserKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeNo  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xDepoKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xIstasyonKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xIsEmriNo  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xOperasyonKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xPartiKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeTarih  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xGonderimTamam  AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER xMiktar  AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER xKayitId AS INTEGER NO-UNDO.

DEFINE DATASET FasonGidisDS FOR FasonGidis.
DEFINE INPUT PARAMETER DATASET FOR FasonGidisDS. 

DEFINE OUTPUT PARAMETER MasterNo AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

{Include3\Baglanti.i}

RUN FasonGidis_run (INPUT xFirmaKod, 
                     INPUT xUserKod, 
                     INPUT xBelgeNo,
                     INPUT xDepoKod,
                     INPUT xIstasyonKod,
                     INPUT xIsEmriNo,
                     INPUT xOperasyonKod,
                     INPUT xPartiKod,
                     INPUT xBelgeTarih,
                     INPUT xGonderimTamam,
                     INPUT xMiktar,
                     INPUT xKayitId,
                     INPUT TABLE FasonGidis,
                     OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).

