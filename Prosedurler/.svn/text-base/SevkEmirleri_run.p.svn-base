/**********************
***********************/
ON FIND OF sevk_emir OVERRIDE DO: END. 
ON FIND OF cari_kart OVERRIDE DO: END.

   DEF TEMP-TABLE SevkEmirleri
      FIELD SevkEmirNo AS CHARACTER FORMAT "X(32)":U  
      FIELD CariKod AS CHARACTER FORMAT "X(32)":U  
      FIELD CariAd AS CHARACTER FORMAT "X(128)":U  
      FIELD Aciklama AS CHARACTER FORMAT "X(64)":U
      FIELD SevkEmriId AS INTEGER      
      FIELD CariId AS INTEGER      
      FIELD YuklemeTarih AS CHARACTER FORMAT "X(10)":U
      FIELD CariGrup AS CHARACTER FORMAT "X(32)":U.
         
DEFINE OUTPUT PARAMETER TABLE FOR SevkEmirleri.

DEFINE INPUT PARAMETER  xCariKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  xCariAd AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  xGrupKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  xSevkEmirNo AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  xDepogoster AS LOGICAL.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH sevk_emir WHERE sevk_emir.firma_kod = Firma 
        AND sevk_emir.emir_durum EQ TRUE  
        AND sevk_emir.emir_no MATCHES "*" + xSevkEmirNo + "*"  
        AND sevk_emir.cari_kod MATCHES "*" + xCariKod + "*" 
        AND sevk_emir.cari_ad MATCHES "*" + xCariAd + "*" 
    NO-LOCK, EACH cari_kart OF sevk_emir 
    WHERE cari_kart.cari_kod MATCHES "*" + xCariKod + "*" AND 
    cari_kart.cgrup_kod3 MATCHES "*" + xGrupKod + "*" NO-LOCK  ON ERROR UNDO, RETURN ERROR:         

    CREATE SevkEmirleri.
       ASSIGN  
          SevkEmirleri.SevkEmirNo=sevk_emir.emir_no
          SevkEmirleri.CariKod = sevk_emir.cari_kod
          SevkEmirleri.CariAd = IF AVAILABLE cari_kart THEN cari_kart.cari_ad ELSE sevk_emir.cari_ad  
          SevkEmirleri.SevkEmriId = sevk_emir.semir_masterno
          SevkEmirleri.CariId = RECID(cari_kart)     
          SevkEmirleri.YuklemeTarih = string(sevk_emir.yukleme_tarih)
          SevkEmirleri.Aciklama = sevk_emir.aciklama
          SevkEmirleri.CariGrup = cari_kart.cgrup_kod3.
        RELEASE SevkEmirleri.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    

    END.


ON FIND OF sevk_emir REVERT. 
ON FIND OF cari_kart REVERT.

