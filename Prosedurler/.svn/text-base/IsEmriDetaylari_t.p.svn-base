/**********************
***********************/

DEF TEMP-TABLE V_IsEmirleri
      FIELD IsEmriId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IsEmriDetayId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IsEmriNo AS CHARACTER FORMAT "X(32)":U
      FIELD ReceteId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD MalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD MalzemeKodu AS CHARACTER /*FORMAT "X(127)":U*/ 
      FIELD MalzemeAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD BirimId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD BirimKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD PlanlananMiktar AS DECIMAL
      FIELD UretilenMiktar AS DECIMAL
      FIELD UretilenNetMiktar AS DECIMAL
      FIELD FireMiktari AS DECIMAL
      FIELD TransferEdilebilecekMiktari AS DECIMAL
      FIELD IstasyonId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IstasyonKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IstasyonAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD RotaId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD RotaKod AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD OperasyonId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD OperasyonNo AS INTEGER
      FIELD OperasyonKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD OperasyonAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IsMerkeziId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IsMerkeziKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IsMerkeziAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD Aciklama AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD DigerId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"     
      FIELD IsEmriTipId AS INTEGER
      FIELD IsEmriTipKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IsEmriTipAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD OzelKod AS CHARACTER /*FORMAT "X(127)":U */
      FIELD DigerKod1 AS CHARACTER /*FORMAT "X(127)":U */
      FIELD BaslangicTarihi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD BaslangicSaat AS CHARACTER /*FORMAT "X(127)":U */
      FIELD BitisTarihi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD BitisSaat AS CHARACTER /*FORMAT "X(127)":U */
      FIELD AcilmaTarihi AS CHARACTER /*FORMAT "X(127)":U*/ .

DEFINE VARIABLE  xEmir AS CHARACTER INITIAL "".
DEFINE VARIABLE  xKod AS CHARACTER INITIAL "101001 FU 0002580".
DEFINE VARIABLE  xAd AS CHARACTER INITIAL "".
DEFINE VARIABLE  xistkod AS CHARACTER INITIAL "".
DEFINE VARIABLE  xoprkod AS CHARACTER INITIAL "".
DEFINE VARIABLE  xFason AS LOGICAL INITIAL FALSE.
DEFINE VARIABLE  xsirano AS INTEGER INITIAL 0.

DEFINE VARIABLE Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE VARIABLE Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN C:\OpenEdge\BarsetProxy\Prosedurler\IsEmriDetaylari_run.p (
    OUTPUT TABLE V_IsEmirleri, 
    INPUT xEmir, INPUT xKod, INPUT xAd, INPUT xistkod, INPUT xoprkod, INPUT xFason, INPUT xsirano, INPUT Firma, INPUT Limit).

FOR EACH V_IsEmirleri:
    DISPLAY V_IsEmirleri.MalzemeKodu.
END.
