
{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{INCLUDE2\degisken2.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}


DEF TEMP-TABLE xdetay_table
            FIELD belge_tarih AS CHAR FORMAT "X(10)"
            FIELD belge_no AS CHAR FORMAT "X(15)"
            FIELD depo_kod AS CHAR FORMAT "X(32)"
            FIELD diger_depo AS CHAR FORMAT "X(32)"
            FIELD cari_kod AS CHAR FORMAT "X(32)"
            FIELD stok_kod AS CHARACTER FORMAT "X(32)":U        
            FIELD hareket_miktar AS DECIMAL
            FIELD Birim AS CHARACTER FORMAT "X(32)":U               
            FIELD sira AS INT FORMAT "->>>".


DEFINE INPUT PARAMETER FirmaKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KullaniciKod AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER BelgeNo      AS CHARACTER NO-UNDO.

DEFINE DATASET xdetay_tableDS FOR xdetay_table.
DEFINE INPUT PARAMETER DATASET FOR xdetay_tableDS. 

DEFINE OUTPUT PARAMETER MasterNo    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir  AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.


RUN KonsinyeCikis_run (INPUT FirmaKod, INPUT KullaniciKod, INPUT BelgeNo,
                       INPUT TABLE xdetay_table, OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).
