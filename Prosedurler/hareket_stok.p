/*********************************************************************************
Stok hareket kaydý oluþturmak için yazýlmýþtýr
                          < Canavar.Toro >
05 Ocak 2011 Perþembe   01:00
                    Hamidiye

*********************************************************************************/

DEF TEMP-TABLE xhareket_table         
            FIELD stok_kod AS CHARACTER
            FIELD giren_depo AS CHARACTER
            FIELD cikan_depo AS CHARACTER
            FIELD miktar AS DECIMAL
            FIELD gelir_gider AS CHARACTER
            FIELD masraf_ad AS CHARACTER
            FIELD masraf_merkez AS CHARACTER
            FIELD analiz_kod  AS CHARACTER
            FIELD parti_kod  AS CHARACTER
            FIELD cari  AS CHARACTER.

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.

DEFINE INPUT PARAMETER bno AS CHARACTER.     
DEFINE INPUT PARAMETER btarih AS CHARACTER. /*LIKE irsaliye_master.belge_tarih*/
DEFINE INPUT PARAMETER hkod AS CHARACTER.
DEFINE INPUT PARAMETER aciklama AS CHARACTER.

DEFINE DATASET StokHareketDS FOR xhareket_table.
DEFINE INPUT PARAMETER DATASET FOR StokHareketDS. 

DEFINE OUTPUT PARAMETER master_no AS INTEGER.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

{Include3\Baglanti.i}

IF hkod EQ "" THEN ASSIGN hkod = "ST-501".

RUN hareket_stok_run(INPUT fkod, INPUT ukod, INPUT bno, INPUT btarih, INPUT hkod, INPUT aciklama, INPUT TABLE xhareket_table, OUTPUT master_no, OUTPUT detay_satir, OUTPUT islem_sonucu).



