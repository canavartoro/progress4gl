

DEFINE TEMP-TABLE irs_master
                  FIELD belge_no         LIKE irsaliye_master.belge_no  
                  FIELD belge_tarih      AS CHAR
                  FIELD hareket_kod      LIKE irsaliye_master.hareket_kod
                  FIELD aciklama         LIKE irsaliye_master.aciklama
                  FIELD mal_tutar        LIKE irsaliye_master.mal_tutar
                  FIELD kdv_tutar        LIKE irsaliye_master.kdv_tutar
                  FIELD irsaliye_tutar   LIKE irsaliye_master.irsaliye_tutar
                  FIELD irsaliye_master  LIKE irsaliye_master.irsaliye_master
                  FIELD xbelge_no   AS CHAR.



DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER btarih AS CHARACTER.

DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

DEFINE DATASET IrsaliyelerDS FOR irs_master.
DEFINE OUTPUT PARAMETER DATASET FOR IrsaliyelerDS. 

{Include3\Baglanti.i}

RUN irs_select_run (INPUT fkod, INPUT ukod, INPUT btarih, OUTPUT islem_sonucu, OUTPUT TABLE irs_master).



