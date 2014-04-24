DEF TEMP-TABLE Malzemeler        
      FIELD  MalzemeKod AS CHARACTER FORMAT "X(32)":U 
      FIELD  MalzemeAd AS CHARACTER FORMAT "X(64)":U 
      FIELD  MalzemeAd2 AS CHARACTER FORMAT "X(64)":U 
      FIELD  Birim AS CHARACTER FORMAT "X(8)":U 
      FIELD  KdvOran AS DECIMAL
      FIELD  MinStok AS DECIMAL
      FIELD  MaxStok AS DECIMAL
      FIELD  FazlaSipOran AS DECIMAL
      FIELD  BirimId AS INTEGER
      FIELD  MalzemeId AS INTEGER
      FIELD  HammaddeTakip AS INTEGER
      FIELD  Tip AS INTEGER
      FIELD  TipKod AS CHARACTER.

DEFINE OUTPUT PARAMETER TABLE FOR Malzemeler.

DEFINE INPUT PARAMETER xkod AS CHARACTER.
DEFINE INPUT PARAMETER xad AS CHARACTER.
DEFINE INPUT PARAMETER xaciklama AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.
DEFINE VARIABLE birimId AS INTEGER INITIAL 0.

FOR EACH stok_kart            
            WHERE stok_kart.firma_kod=Firma
                AND aktif_pasif="Aktif"
                AND (stok_kod = xkod OR xkod EQ "")
                AND (stok_ad BEGINS xad OR xad EQ "")
                AND (stok_ad2 BEGINS xaciklama OR xaciklama EQ "")
                NO-LOCK ON ERROR UNDO, RETURN ERROR:

    FIND birim WHERE birim.firma_kod = Firma AND birim.birim = stok_kart.birim NO-LOCK NO-ERROR.
    
    IF AVAILABLE birim THEN birimId = RECID(birim).

     CREATE Malzemeler.
       ASSIGN
           Tip = IF stok_kart.urun_tip = "Hammadde" THEN 1 ELSE IF stok_kart.urun_tip = "Y.Mamul" THEN 2 ELSE IF stok_kart.urun_tip = "Mamul" THEN 3 ELSE 0
           TipKod = stok_kart.urun_tip
           MalzemeKod = stok_kod
           MalzemeAd = stok_ad
           MalzemeAd2 = stok_ad2
           Malzemeler.Birim = stok_kart.birim
           Malzemeler.KdvOran = stok_kart.kdv_oran
           Malzemeler.MinStok = stok_kart.min_stok
           Malzemeler.MaxStok = stok_kart.max_stok
           Malzemeler.BirimId = birimId
           Malzemeler.FazlaSipOran = stok_kart.fazla_sipyuzde
           Malzemeler.HammaddeTakip = stok_kart.int_sira
           Malzemeler.MalzemeId = RECID(stok_kart).                
         RELEASE Malzemeler.
             
         Row_Limit = Row_Limit + 1.
             
         IF Row_Limit GE Limit THEN DO: 
             LEAVE. 
         END.
    
    END.
