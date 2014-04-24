

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



DEFINE VARIABLE fkod AS CHARACTER INITIAL "ARMA2011".
DEFINE VARIABLE ukod AS CHARACTER INITIAL "00205".
DEFINE VARIABLE btarih AS CHARACTER INITIAL "06.01.2014".

DEFINE VARIABLE islem_sonucu AS CHARACTER INITIAL "".

{Include3\Baglanti.i}

RUN C:\OpenEdge\BarsetProxy\Prosedurler\irs_select_run.p (INPUT fkod, INPUT ukod, INPUT btarih, OUTPUT islem_sonucu, OUTPUT TABLE irs_master).

FOR EACH irs_master:
    DISPLAY irs_master.
END.



