

DEFINE INPUT PARAMETER fkod AS CHARACTER.
DEFINE INPUT PARAMETER ukod AS CHARACTER.
DEFINE INPUT PARAMETER bno AS CHARACTER.

DEFINE OUTPUT PARAMETER barset_belge AS CHARACTER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.
DEFINE OUTPUT PARAMETER rmaster_no AS INTEGER FORMAT ">>>,>>>,>>>,>>9".

DEFINE INPUT PARAMETER master_no AS INTEGER.

{Include3\Baglanti.i}

RUN irs_delete_run (INPUT fkod, INPUT ukod, INPUT bno, 
                    OUTPUT barset_belge, OUTPUT islem_sonucu, OUTPUT rmaster_no, INPUT master_no).



