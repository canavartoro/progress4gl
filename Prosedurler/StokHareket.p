



DEFINE TEMP-TABLE xStokHareket
    FIELD StokKod       AS CHARACTER    COLUMN-LABEL "stok_kod"
    FIELD Birim         AS CHARACTER    COLUMN-LABEL "dbirim"
    FIELD Miktar        AS DECIMAL      COLUMN-LABEL "dmiktar"
    FIELD GelirGider    AS CHARACTER    COLUMN-LABEL "gelirgider_kod"
    FIELD MasrafAd      AS CHARACTER    COLUMN-LABEL "masraf_ad"
    FIELD MasrafMerkez  AS CHARACTER    COLUMN-LABEL "masraf_merkez"
    FIELD AnalizKod     AS CHARACTER    COLUMN-LABEL "analiz_kod"
    FIELD PartiKod      AS CHARACTER    COLUMN-LABEL "parti_kod"
    FIELD Aciklama      AS CHARACTER    COLUMN-LABEL "aciklama"
    FIELD Aciklama2     AS CHARACTER    COLUMN-LABEL "aciklama2"
    FIELD Aciklama3     AS CHARACTER    COLUMN-LABEL "aciklama3"
    FIELD IslemNedeni   AS CHARACTER    COLUMN-LABEL "cikis_neden"
    FIELD IslemNedenAd  AS CHARACTER    COLUMN-LABEL "neden_ad".

DEFINE INPUT PARAMETER FirmaKod     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER KullaniciKod AS CHARACTER NO-UNDO.

DEFINE INPUT PARAMETER BelgeNo      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER BelgeTarih   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER HareketKod   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER DepoKod      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER DigerDepo    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER CariKod      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER Aciklama     AS CHARACTER NO-UNDO.

DEFINE DATASET xStokHareketDS FOR xStokHareket.
DEFINE INPUT PARAMETER DATASET FOR xStokHareketDS. 

DEFINE OUTPUT PARAMETER MasterNo    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir  AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

{Include3\Baglanti.i}

IF HareketKod EQ "" THEN ASSIGN HareketKod = "ST-501".

RUN StokHareket_run (INPUT FirmaKod, INPUT KullaniciKod, 
                     INPUT BelgeNo, INPUT BelgeTarih, INPUT HareketKod,INPUT DepoKod, INPUT DigerDepo, INPUT CariKod, INPUT Aciklama, 
                     INPUT TABLE xStokHareket, OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).


