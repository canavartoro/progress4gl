/**********************
***********************/

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

ON FIND OF erp_master OVERRIDE DO: END.
ON FIND OF erp_detay OVERRIDE DO: END.
ON FIND OF erp_recete OVERRIDE DO: END.

DEF TEMP-TABLE V_Receteler
    FIELD ReceteId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD IsEmriId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD IsEmriNo AS CHARACTER FORMAT "X(32)":U
    FIELD IsEmriMiktar AS DECIMAL
    FIELD SatirNo AS INTEGER
    FIELD BirimId AS INTEGER
    FIELD Birim AS CHARACTER FORMAT "X(16)":U
    FIELD MalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD MalzemeKod AS CHARACTER
    FIELD MalzemeAd AS CHARACTER
    FIELD OperasyonId AS INTEGER
    FIELD OperasyonNo AS INTEGER
    FIELD OperasyonKod AS CHARACTER
    FIELD BirimMiktar AS DECIMAL
    FIELD NetMiktar AS DECIMAL
    FIELD OzelKod AS CHARACTER
    FIELD PartiKod AS CHARACTER
    FIELD MiktarSekli AS LOGICAL
    FIELD HammaddeTakip AS INTEGER
    FIELD UstMalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD UstMalzemeKod AS CHARACTER
    FIELD UstMalzemeAd AS CHARACTER.
   
DEFINE OUTPUT PARAMETER TABLE FOR V_Receteler.

DEFINE INPUT PARAMETER  xIsEmri AS CHARACTER FORMAT "X(64)":U.

DEFINE INPUT PARAMETER Firma AS CHARACTER FORMAT "X(64)":U INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER.
DEFINE VARIABLE Row_Limit AS INTEGER.

/*OUTPUT TO VALUE("C:\OpenEdge\barset\log\recete" + xIsEmri + REPLACE(STRING(TIME,'HH:MM:SS'),":","") + ".log").*/

DEFINE VARIABLE uretilen AS DECIMAL INITIAL 0.
DEFINE VARIABLE kalan AS DECIMAL INITIAL 0.
DEFINE VARIABLE stok-miktar AS DECIMAL INITIAL 0.
DEFINE VARIABLE ur_miktar AS DECIMAL NO-UNDO INITIAL 0.
DEF BUFFER skart FOR stok_kart.

FOR EACH erp_master WHERE erp_master.firma_kod = Firma AND erp_master.isemri_no = xIsEmri NO-LOCK:
    FOR EACH erp_recete OF erp_master, EACH skart OF erp_master NO-LOCK:
        FOR EACH stok_kart OF erp_recete, EACH operasyon_kart2 OF erp_recete NO-LOCK: 	

            FIND birim WHERE birim.firma_kod = Firma AND birim.birim = erp_recete.dbirim NO-LOCK NO-ERROR.

            kalan = erp_master.pmiktar.
            CREATE V_Receteler.
            ASSIGN 
				V_Receteler.ReceteId = RECID(erp_recete)
                V_Receteler.IsEmriId = erp_master.erp_masterno
                V_Receteler.IsEmriNo = erp_master.isemri_no
                V_Receteler.IsEmriMiktar = erp_master.pmiktar
                V_Receteler.MalzemeId = RECID(stok_kart)
                V_Receteler.MalzemeKod = erp_recete.stok_kod
                V_Receteler.MalzemeAd = stok_kart.stok_ad
                V_Receteler.OperasyonId = RECID(operasyon_kart2)
                V_Receteler.OperasyonNo = 10
                V_Receteler.SatirNo = 10
                V_Receteler.OperasyonKod = erp_recete.operasyon_kod
                V_Receteler.BirimMiktar = erp_recete.miktar
                V_Receteler.OzelKod = erp_recete.recete_kod
                V_Receteler.PartiKod = erp_recete.parti_kod
                V_Receteler.MiktarSekli = erp_recete.miktar_sekli
                V_Receteler.BirimId = IF AVAILABLE birim THEN INT(RECID(birim)) ELSE 0
                V_Receteler.Birim = erp_recete.dbirim
                V_Receteler.NetMiktar = IF ur_miktar = 0 THEN kalan * erp_recete.miktar ELSE ur_miktar * erp_recete.miktar
                V_Receteler.HammaddeTakip = stok_kart.int_sira
                V_Receteler.UstMalzemeId = RECID(skart)
                V_Receteler.UstMalzemeKod = skart.stok_kod
                V_Receteler.UstMalzemeAd = skart.stok_ad.
            RELEASE V_Receteler.
			Row_Limit = Row_Limit + 1.
			IF Row_Limit GE Limit THEN LEAVE.
		END.
	END.					              
END.

/*OUTPUT CLOSE.*/

ON FIND OF erp_master REVERT.
ON FIND OF erp_detay REVERT.
ON FIND OF erp_recete REVERT.          



