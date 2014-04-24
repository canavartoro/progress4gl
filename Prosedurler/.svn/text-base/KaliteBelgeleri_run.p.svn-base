


DEFINE TEMP-TABLE V_KaliteBelgeleri
    FIELD StokKod AS CHARACTER
    FIELD StokAd AS CHARACTER
    FIELD Birim AS CHARACTER
    FIELD GMiktar AS DECIMAL
    FIELD CMiktar AS DECIMAL
    FIELD DepoKod AS CHARACTER
    FIELD OnayKod AS CHARACTER
    FIELD Durum AS CHARACTER.

DEFINE OUTPUT PARAMETER TABLE FOR V_KaliteBelgeleri.

DEFINE INPUT PARAMETER Firma AS CHARACTER.
DEFINE INPUT PARAMETER xCari AS CHARACTER.
DEFINE INPUT PARAMETER xBelge AS CHARACTER.
DEFINE INPUT PARAMETER xStok AS CHARACTER.
DEFINE INPUT PARAMETER Limit AS INTEGER.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0 NO-UNDO.

DEFINE VARIABLE rapsartlar_par AS CHARACTER INITIAL " 1 = 2 ".
DEFINE VARIABLE hbuff# AS HANDLE NO-UNDO.
DEFINE VARIABLE hquer# AS HANDLE NO-UNDO.

DEFINE VARIABLE hfiel# AS HANDLE NO-UNDO.
DEFINE VARIABLE hfiel2# AS HANDLE NO-UNDO.
DEFINE VARIABLE hfiel3# AS HANDLE NO-UNDO.

ASSIGN rapsartlar_par = "firma_kod = " + CHR(34) + Firma + CHR(34) + 
    " AND cari_kod = " + CHR(34) + xCari + CHR(34) +
    " AND gbelge_no = " + CHR(34) + xBelge + CHR(34) +
    " AND stok_kod = " + CHR(34) + xStok + CHR(34) +
    " AND gbelge_tarih >= 01/01/2011 ".


DEFINE VARIABLE ctabl# AS CHARACTER INITIAL "ky_omaster" NO-UNDO. /* table name */

CREATE BUFFER hbuff# FOR TABLE ctabl#.
CREATE QUERY hquer#.
hquer#:ADD-BUFFER(hbuff#).


hquer#:QUERY-PREPARE(SUBSTITUTE("FOR EACH &1  where &2 NO-LOCK", hbuff#:NAME,rapsartlar_par)).
hquer#:QUERY-OPEN().
hquer#:GET-FIRST().

DO  WHILE hquer#:QUERY-OFF-END = FALSE:

    FIND FIRST ky_onaytip WHERE ky_onaytip.firma_kod = Firma AND ky_onaytip.onay_kod = hbuff#:BUFFER-FIELD("onay_kod"):BUFFER-VALUE NO-LOCK NO-ERROR.

    CREATE V_KaliteBelgeleri.
    ASSIGN
        V_KaliteBelgeleri.StokKod = hbuff#:BUFFER-FIELD("stok_kod"):BUFFER-VALUE
        V_KaliteBelgeleri.StokAd = hbuff#:BUFFER-FIELD("stok_ad"):BUFFER-VALUE
        V_KaliteBelgeleri.Birim = hbuff#:BUFFER-FIELD("dbirim"):BUFFER-VALUE
        V_KaliteBelgeleri.GMiktar = hbuff#:BUFFER-FIELD("giren_miktar"):BUFFER-VALUE
        V_KaliteBelgeleri.CMiktar = hbuff#:BUFFER-FIELD("cikan_miktar"):BUFFER-VALUE
        V_KaliteBelgeleri.DepoKod = hbuff#:BUFFER-FIELD("depo_kod"):BUFFER-VALUE
        V_KaliteBelgeleri.OnayKod = hbuff#:BUFFER-FIELD("onay_kod"):BUFFER-VALUE
        V_KaliteBelgeleri.Durum = IF AVAILABLE ky_onaytip THEN ky_onaytip.statu ELSE "".
    RELEASE V_KaliteBelgeleri. 
    
    /*Row_Limit = Row_Limit + 1.

    IF Row_Limit GE Limit THEN DO: LEAVE. END.*/

    hquer#:GET-NEXT().

END.


DELETE OBJECT hquer#.
DELETE OBJECT hbuff#.
