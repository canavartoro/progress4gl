

DEF TEMP-TABLE xsay_table
            FIELD stok_kod        AS CHARACTER 
            FIELD miktar          AS DECIMAL
            FIELD parti_kod       AS CHARACTER 
            FIELD renk_no         AS CHARACTER 
            FIELD kalite_kod      AS CHARACTER
            FIELD ozellik_kod1    AS CHARACTER
            FIELD ozellik_kod2    AS CHARACTER
            FIELD ozellik_kod3    AS CHARACTER
            FIELD raf_kod         AS CHARACTER.
    /*INDEX kod1 IS UNIQUE PRIMARY stok_kod parti_kod.*/

DEFINE DATASET SayimlarDS FOR xsay_table.
DEFINE INPUT PARAMETER DATASET FOR SayimlarDS.

DEFINE INPUT PARAMETER fkod  AS CHARACTER.
DEFINE INPUT PARAMETER ukod  AS CHARACTER.
DEFINE INPUT PARAMETER bno AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER.
DEFINE INPUT PARAMETER depokod AS CHARACTER.

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

{Include3\Baglanti.i}

RUN FiiliSayimKaydet_run.r(INPUT TABLE xsay_table, 
                      INPUT fkod, 
                      INPUT ukod,
                      INPUT bno,
                      INPUT btarih,
                      INPUT depokod,
                      OUTPUT master_no, OUTPUT detay_satir, OUTPUT islem_sonucu).

