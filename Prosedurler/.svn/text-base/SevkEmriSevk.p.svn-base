/*********************************************************************************
Sevk emrinden irsaliye oluþturmak için yazýlmýþtýr
                          < Canavar.Toro >
30 Mayýs 2011 Pazartesi   20:39
*********************************************************************************/

DEF TEMP-TABLE xsevk_table 
            FIELD semir_masterno AS INTEGER
            FIELD semir_detayno AS INTEGER
            FIELD dmiktar AS DECIMAL
            FIELD partino AS CHARACTER.


DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.

DEFINE INPUT PARAMETER bno AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER. /*LIKE irsaliye_master.belge_tarih*/
DEFINE INPUT PARAMETER fiilitestlimtarih AS CHARACTER.
DEFINE INPUT PARAMETER hkod AS CHARACTER.
DEFINE INPUT PARAMETER nakliyetip AS CHARACTER.
DEFINE INPUT PARAMETER nakliyecikod AS CHARACTER.
DEFINE INPUT PARAMETER arackod AS CHARACTER.
DEFINE INPUT PARAMETER aciklama AS CHARACTER.
DEFINE INPUT PARAMETER s_adres1 AS CHARACTER INITIAL "".
DEFINE INPUT PARAMETER s_adres2 AS CHARACTER INITIAL "".
DEFINE INPUT PARAMETER s_adres3 AS CHARACTER INITIAL "".

DEFINE DATASET SevklerDS FOR xsevk_table.
DEFINE INPUT PARAMETER DATASET FOR SevklerDS. 

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

{Include3\Baglanti.i}

RUN SevkEmriSevk_run (INPUT fkod, INPUT ukod, INPUT bno, 
                       INPUT btarih, INPUT fiilitestlimtarih, INPUT hkod, 
                       INPUT nakliyetip, INPUT nakliyecikod, INPUT arackod, 
                       INPUT aciklama, INPUT s_adres1, INPUT s_adres2, INPUT s_adres3, INPUT TABLE xsevk_table, OUTPUT master_no, OUTPUT detay_satir, OUTPUT islem_sonucu).



