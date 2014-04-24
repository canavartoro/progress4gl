/**********************
***********************/
ON FIND OF cari_kart OVERRIDE DO: END.
ON FIND OF cari_stokkodu OVERRIDE DO: END.

   DEF TEMP-TABLE Cariler
      FIELD CariId AS INTEGER
      FIELD CariKod AS CHARACTER FORMAT "X(32)":U 
      FIELD CariAd AS CHARACTER FORMAT "X(127)":U 
      FIELD KisaAd AS CHARACTER FORMAT "X(127)":U 
      FIELD BolgeKod AS CHARACTER FORMAT "X(31)":U 
      FIELD Adres1 AS CHARACTER FORMAT "X(255)":U 
      FIELD Adres2 AS CHARACTER FORMAT "X(255)":U 
      FIELD Adres3 AS CHARACTER FORMAT "X(255)":U 
      FIELD FaturaAdres1 AS CHARACTER FORMAT "X(255)":U 
      FIELD FaturaAdres2 AS CHARACTER FORMAT "X(255)":U 
      FIELD FaturaAdres3 AS CHARACTER FORMAT "X(255)":U 
      FIELD VarigDaire AS CHARACTER FORMAT "X(63)":U 
      FIELD VergiNo AS CHARACTER FORMAT "X(63)":U
      FIELD GrupKod AS CHARACTER FORMAT "X(63)":U. /*cgrup_kod3*/
      
   
DEFINE OUTPUT PARAMETER TABLE FOR Cariler.

DEFINE INPUT PARAMETER  xId AS INTEGER.
DEFINE INPUT PARAMETER  xId2 AS INTEGER.

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAd AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER  xKod1 AS CHARACTER.
DEFINE INPUT PARAMETER  xKod2 AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

IF xKod2 EQ ? OR xKod2 EQ "" THEN DO:
FOR EACH cari_kart
            WHERE cari_kart.aktif_pasif EQ "Aktif" AND cari_kart.firma_kod=Firma  AND
                  cari_kart.cari_ad  BEGINS   xAd  AND
                  cari_kart.cari_kod   MATCHES   "*" + xKod + "*"   AND
                  cari_kart.kisa_ad   BEGINS   xAciklama AND
                  cari_kart.bolge_kod BEGINS   xKod1 
              NO-LOCK ON ERROR UNDO, RETURN ERROR:
         
    CREATE Cariler.
       ASSIGN
               Cariler.CariId = RECID(cari_kart)
               Cariler.CariKod = cari_kart.cari_kod
               Cariler.CariAd = cari_kart.cari_ad
               Cariler.KisaAd = cari_kart.kisa_ad
               Cariler.BolgeKod = cari_kart.bolge_kod
               Cariler.Adres1 = cari_kart.adres1
               Cariler.Adres2 = cari_kart.adres2
               Cariler.Adres3 = cari_kart.adres3
               Cariler.FaturaAdres1 = fat_adres1
               Cariler.FaturaAdres2 = fat_adres2
               Cariler.FaturaAdres3 = fat_adres3
               Cariler.VarigDaire = cari_kart.vergi_daire
               Cariler.VergiNo =   cari_kart.vergi_no  
               Cariler.GrupKod =   cari_kart.cgrup_kod3.
         RELEASE Cariler.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.

END. /*FOR EACH cari_kart*/
END. /*IF xKod2 EQ ?*/
ELSE DO:
    FOR EACH cari_stokkodu WHERE cari_stokkodu.firma_kod = Firma 
        /*AND cari_stokkodu.cari_kod MATCHES   "*" + xKod + "*" */
        AND cari_stokkodu.stok_kod EQ xKod2 NO-LOCK,
      EACH cari_kart WHERE cari_kart.firma_kod = cari_stokkodu.firma_kod 
        AND cari_kart.cari_kod = cari_stokkodu.cari_kod NO-LOCK ON ERROR UNDO, RETURN ERROR:

        CREATE Cariler.
       ASSIGN
               Cariler.CariId = RECID(cari_kart)
               Cariler.CariKod = cari_kart.cari_kod
               Cariler.CariAd = cari_kart.cari_ad
               Cariler.KisaAd = cari_kart.kisa_ad
               Cariler.BolgeKod = cari_kart.bolge_kod
               Cariler.Adres1 = cari_kart.adres1
               Cariler.Adres2 = cari_kart.adres2
               Cariler.Adres3 = cari_kart.adres3
               Cariler.FaturaAdres1 = cari_kart.fat_adres1
               Cariler.FaturaAdres2 = cari_kart.fat_adres2
               Cariler.FaturaAdres3 = cari_kart.fat_adres3
               Cariler.VarigDaire = cari_kart.vergi_daire
               Cariler.VergiNo =   cari_kart.vergi_no
               Cariler.GrupKod =   cari_kart.cgrup_kod3.
         RELEASE Cariler.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.

    END.
END.

ON FIND OF cari_kart REVERT.
ON FIND OF cari_stokkodu REVERT.
