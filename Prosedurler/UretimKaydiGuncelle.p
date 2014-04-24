

    /***************   local variable   ************************/
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
            FIELD skk_no          AS CHARACTER
            FIELD aciklama1       AS CHARACTER
            FIELD aciklama2       AS CHARACTER
            FIELD aciklama3       AS CHARACTER
            FIELD aciklama4       AS CHARACTER
            FIELD aciklama5       AS CHARACTER
            FIELD aciklama6       AS CHARACTER.

DEF TEMP-TABLE xis_table
            FIELD ukayit_no     AS CHARACTER
            FIELD personel_kod  AS CHARACTER
			FIELD bas_tarihi    AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER
            FIELD aciklama      AS CHARACTER.

DEF TEMP-TABLE xdur_table
            FIELD ukayit_no     AS CHARACTER
            FIELD durus_kod     AS CHARACTER
            FIELD tezgah_kod    AS CHARACTER
            FIELD baslangic     AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER
            FIELD aciklama      AS CHARACTER
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
    FIELD PartiNo AS CHARACTER FORMAT "X(30)"
    FIELD MiktarSekli AS INTEGER.

DEF TEMP-TABLE xkayit_table /*hangi kayitlarin guncellendigini tutmak icin*/
            FIELD Malzemeler  AS LOGICAL
            FIELD Iscilikler  AS LOGICAL
			FIELD Duruslar    AS LOGICAL
            FIELD Hurdalar    AS LOGICAL
            FIELD Aletler     AS LOGICAL.

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER logfile AS CHARACTER.
DEFINE INPUT PARAMETER partikod AS CHARACTER.

DEFINE DATASET KayitDS FOR xkayit_table.
DEFINE INPUT PARAMETER DATASET FOR KayitDS.

DEFINE DATASET OperasyonDS FOR xop_table.
DEFINE INPUT PARAMETER DATASET FOR OperasyonDS.

DEFINE DATASET IscilikDS FOR xis_table.
DEFINE INPUT PARAMETER DATASET FOR IscilikDS.

DEFINE DATASET DurusDS FOR xdur_table.
DEFINE INPUT PARAMETER DATASET FOR DurusDS.

DEFINE DATASET HurdaDS FOR xhur_table.
DEFINE INPUT PARAMETER DATASET FOR HurdaDS.

DEFINE DATASET AletDS FOR xalet_table.
DEFINE INPUT PARAMETER DATASET FOR AletDS.

DEFINE DATASET MalzemeDS FOR Malzemeler.
DEFINE INPUT PARAMETER DATASET FOR MalzemeDS.

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

{Include3\Baglanti.i}

RUN UretimKaydiGuncelle_run.r(INPUT fkod, 
                      INPUT ukod, 
                      INPUT logfile,
                      INPUT partikod,
                      INPUT TABLE xkayit_table,
                      INPUT TABLE xop_table,
                      INPUT TABLE xis_table,
                      INPUT TABLE xdur_table, 
                      INPUT TABLE xhur_table,
                      INPUT TABLE xalet_table,
                      INPUT TABLE Malzemeler, OUTPUT master_no, OUTPUT detay_satir, OUTPUT islem_sonucu).
