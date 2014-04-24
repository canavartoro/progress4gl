



DEF TEMP-TABLE xop_table
            FIELD kayit_no        AS CHARACTER 
            FIELD isemri_no       AS CHARACTER 
            FIELD operasyon_kod   AS CHARACTER 
            FIELD istasyon_kod    AS CHARACTER 
            FIELD bas_tarihi      AS CHARACTER
            FIELD bas_saati       AS CHARACTER
            FIELD bit_tarihi      AS CHARACTER            
            FIELD bit_saati       AS CHARACTER
            FIELD miktar          AS DECIMAL 
            FIELD kat_sayi        AS DECIMAL 
            FIELD kat_sayi2       AS DECIMAL
            FIELD vardiya_kod     AS CHARACTER
            FIELD skk_no          AS CHARACTER.

DEF TEMP-TABLE xis_table
            FIELD ukayit_no     AS CHARACTER
            FIELD personel_kod  AS CHARACTER
			FIELD bas_tarihi    AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER.			

DEF TEMP-TABLE xdur_table
            FIELD ukayit_no     AS CHARACTER
            FIELD durus_kod     AS CHARACTER
            FIELD tezgah_kod    AS CHARACTER
            FIELD baslangic     AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER
            FIELD sure          AS INT
            FIELD sirano        AS INT.

DEF TEMP-TABLE xhur_table
            FIELD ukayit_no     AS CHARACTER
            FIELD hurda_skod    AS CHARACTER
            FIELD hurda_sbirim  AS CHARACTER
            FIELD hurda_kod     AS CHARACTER
            FIELD aciklama     AS CHARACTER
            FIELD diger_depo    AS CHARACTER
            FIELD parti_kod    AS CHARACTER
            FIELD miktar        AS DECIMAL.

DEF TEMP-TABLE xalet_table
            FIELD ukayit_no     AS CHARACTER
            FIELD platform_kod    AS CHARACTER
            FIELD platform_ad    AS CHARACTER.

DEFINE TEMP-TABLE Malzemeler
    FIELD Alternatif AS LOGICAL 
    FIELD DepoKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod2 AS CHARACTER FORMAT "X(30)"
    FIELD Birim AS CHARACTER FORMAT "X(10)"
    FIELD KMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD FMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)".
