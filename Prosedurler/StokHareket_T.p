

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

DEFINE VARIABLE FirmaKod AS CHARACTER INITIAL "ARMA2011".
DEFINE VARIABLE KullaniciKod AS CHARACTER INITIAL "uroot".

DEFINE VARIABLE BelgeNo AS CHARACTER INITIAL "12211221".
DEFINE VARIABLE BelgeTarih AS CHARACTER INITIAL "18/02/2014".
DEFINE VARIABLE HareketKod AS CHARACTER INITIAL "ST-201".
DEFINE VARIABLE DepoKod AS CHARACTER INITIAL "A00200".
DEFINE VARIABLE DigerDepo AS CHARACTER INITIAL "".
DEFINE VARIABLE CariKod AS CHARACTER INITIAL "".
DEFINE VARIABLE Aciklama AS CHARACTER INITIAL "deneme".

DEFINE VARIABLE MasterNo AS INTEGER INITIAL 0.
DEFINE VARIABLE DetaySatir AS INTEGER INITIAL 0.
DEFINE VARIABLE IslemSonucu AS CHARACTER INITIAL "".

CREATE xStokHareket.
ASSIGN
    xStokHareket.StokKod = "101502 AU 0002773"
    xStokHareket.Birim = "ad"
    xStokHareket.Miktar = 300
    xStokHareket.GelirGider = ""
    xStokHareket.MasrafAd = ""
    xStokHareket.MasrafMerkez = ""
    xStokHareket.AnalizKod = ""
    xStokHareket.PartiKod = "paqrti"
    xStokHareket.Aciklama = "deneme 1"
    xStokHareket.Aciklama3 = "deneme 1"
    xStokHareket.IslemNedeni = ""
    xStokHareket.IslemNedenAd = "".
RELEASE xStokHareket.


RUN C:\OpenEdge\BarsetProxy\Prosedurler\StokHareket_run.p(INPUT FirmaKod, INPUT KullaniciKod, 
                     INPUT BelgeNo, INPUT BelgeTarih, INPUT HareketKod,INPUT DepoKod, INPUT DigerDepo, INPUT CariKod, INPUT Aciklama, 
                     INPUT TABLE xStokHareket, OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).

MESSAGE MasterNo "" DetaySatir "" IslemSonucu VIEW-AS ALERT-BOX ERROR TITLE "Hata".
