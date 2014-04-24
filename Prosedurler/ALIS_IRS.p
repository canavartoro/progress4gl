/*********************************************************************************
SIPARISTEN IRSALIYE OLUSTURMAK ICIN..
                          < Canavar.Toro >
28 OCAK 2011 CUMA 18:30
                    BARSET BILGI SISTEMLERI
*********************************************************************************/

DEF TEMP-TABLE xdetay_table         
            FIELD stok_kod AS CHARACTER FORMAT "X(32)":U        
            FIELD hareket_miktar AS DECIMAL
            FIELD Birim AS CHARACTER FORMAT "X(32)":U  
            FIELD sip_detayno AS INTEGER
            FIELD smaster AS INTEGER
            FIELD PartiNo  AS CHARACTER FORMAT "X(32)":U        
            FIELD SonKul  AS CHARACTER FORMAT "X(32)":U
            FIELD OzKod1  AS CHARACTER FORMAT "X(32)":U
            FIELD Acikla1 AS CHARACTER FORMAT "X(32)":U         
            FIELD Acikla2 AS CHARACTER FORMAT "X(32)":U         
            FIELD Acikla3 AS CHARACTER FORMAT "X(32)":U
            FIELD sira AS INT FORMAT "->>>".

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER bno AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER. 
DEFINE INPUT PARAMETER fiilitestlimtarih AS CHARACTER.
DEFINE INPUT PARAMETER alis_satis AS CHARACTER.
DEFINE INPUT PARAMETER cari AS CHARACTER.
DEFINE INPUT PARAMETER hkod AS CHARACTER.
DEFINE INPUT PARAMETER Aciklama1 AS CHARACTER FORMAT "X(32)":U.         
DEFINE INPUT PARAMETER Aciklama2 AS CHARACTER FORMAT "X(32)":U.  

DEFINE DATASET AlisIrsaliyeDS FOR xdetay_table.
DEFINE INPUT PARAMETER DATASET FOR AlisIrsaliyeDS.

DEFINE OUTPUT PARAMETER master_no AS INTEGER.
DEFINE OUTPUT PARAMETER detay_satir AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER FORMAT "X(128)":U.

{Include3\Baglanti.i}

RUN ALIS_IRS_run (INPUT fkod, INPUT ukod, INPUT bno, INPUT btarih, INPUT fiilitestlimtarih, INPUT alis_satis, INPUT cari, INPUT hkod,INPUT Aciklama1 , INPUT Aciklama2, INPUT TABLE xdetay_table, OUTPUT master_no, OUTPUT detay_satir, OUTPUT islem_sonucu).

