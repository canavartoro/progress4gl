/*
Canavar.Toro
02 Mayýs 2012 02:30 Arma Filitre 
*/

DEFINE INPUT PARAMETER MalzemeBirimId  AS INTEGER.
DEFINE INPUT PARAMETER Oran  AS DECIMAL.
DEFINE INPUT PARAMETER Oran2  AS DECIMAL.
DEFINE OUTPUT PARAMETER IslemSonucu AS LOGICAL INITIAL FALSE.

{Include3\Baglanti.i}

OUTPUT TO VALUE(barset-log-dir + "\brmgncll_" + STRING(MalzemeBirimId) + ".txt").

RUN BirimGuncelle_run (INPUT MalzemeBirimId, INPUT Oran, INPUT Oran2, OUTPUT IslemSonucu).

OUTPUT CLOSE.
