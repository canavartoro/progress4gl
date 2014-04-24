DEF TEMP-TABLE MalzemeBirim
    FIELD MalzemeBirimId AS INTEGER
    FIELD BirimId AS INTEGER
    FIELD BirimKod AS CHARACTER FORMAT "X(8)":U
    FIELD MalzemeId AS INTEGER
    FIELD MalzemeKod AS CHARACTER FORMAT "X(8)":U
    FIELD Miktar AS DECIMAL FORMAT "->>>>,>>9.999<<<<"
    FIELD Miktar2 AS DECIMAL FORMAT "->>>>,>>9.999<<<<"
    FIELD SiraNo AS INTEGER
    FIELD En AS DECIMAL FORMAT ">>>,>>9.99"
    FIELD Boy AS DECIMAL FORMAT ">>>,>>9.99" 
    FIELD Yukekseklik AS DECIMAL FORMAT ">>>,>>9.99"
    FIELD Hacim AS DECIMAL FORMAT "->>>,>>9.99<<<<<" 
    FIELD Agirlik AS DECIMAL FORMAT ">>>,>>>,>>>.<<<<<".    
           
DEFINE OUTPUT PARAMETER TABLE FOR MalzemeBirim.  

DEFINE INPUT PARAMETER  AraBirimKod AS CHARACTER FORMAT "X(8)":U. 
DEFINE INPUT PARAMETER  AraMalzemeKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  AraMalzemeId AS INTEGER FORMAT ">>>>>>>>>>>>>>>>>9.99".

DEFINE INPUT PARAMETER Firma AS CHARACTER FORMAT "x(8)":U INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.
DEFINE VARIABLE iLoop AS INTEGER INITIAL 0.

FOR EACH stok_kart 
    WHERE stok_kart.firma_kod = Firma  AND (/*RECID(stok_kart) EQ AraMalzemeId OR*/ stok_kart.stok_kod = AraMalzemeKod) NO-LOCK USE-INDEX stok_idx:
 

    FOR EACH stok_birim 
        WHERE stok_kart.firma_kod = stok_birim.firma_kod 
        AND stok_birim.stok_kod = stok_kart.stok_kod NO-LOCK, EACH birim OF stok_birim NO-LOCK:

         CREATE MalzemeBirim.
           ASSIGN
               MalzemeBirim.MalzemeBirimId = RECID(stok_birim)
               MalzemeBirim.BirimId = RECID(birim)
               MalzemeBirim.BirimKod = stok_birim.birim
               MalzemeBirim.MalzemeId = RECID(stok_kart)
               MalzemeBirim.MalzemeKod = stok_kart.stok_kod
               MalzemeBirim.Miktar = stok_birim.oran2
               MalzemeBirim.Miktar2 = stok_birim.oran / stok_birim.oran2
               MalzemeBirim.SiraNo = stok_birim.sira_no
               MalzemeBirim.En = stok_birim.en
               MalzemeBirim.Boy = stok_birim.boy
               MalzemeBirim.Yukekseklik = stok_birim.yukseklik
               MalzemeBirim.Hacim = stok_birim.hacim
               MalzemeBirim.Agirlik = stok_birim.agirlik.
               RELEASE MalzemeBirim.
               iLoop = iLoop + 1.
    END.

    IF iLoop < 1 THEN DO:

        FIND birim WHERE birim.firma_kod = stok_kart.firma_kod AND stok_kart.birim = birim.birim NO-LOCK NO-ERROR.

        CREATE MalzemeBirim.
           ASSIGN
               MalzemeBirim.MalzemeBirimId = RECID(stok_kart)
               MalzemeBirim.BirimId = RECID(birim)
               MalzemeBirim.BirimKod = birim.birim
               MalzemeBirim.MalzemeId = RECID(stok_kart)
               MalzemeBirim.MalzemeKod = stok_kart.stok_kod
               MalzemeBirim.Miktar = 1
               MalzemeBirim.Miktar2 = 1
               MalzemeBirim.SiraNo = 0
               MalzemeBirim.En = 0
               MalzemeBirim.Boy = 0
               MalzemeBirim.Yukekseklik = 0
               MalzemeBirim.Hacim = 0
               MalzemeBirim.Agirlik = 0.
               RELEASE MalzemeBirim.
    END.

END.
