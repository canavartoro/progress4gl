/**********************
***********************/

ON FIND OF erp_detay2 OVERRIDE DO: END.
ON FIND OF erp_detay2 OVERRIDE DO: END.
ON FIND OF erp_durustip OVERRIDE DO: END.
ON WRITE OF erp_durus OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE V_IsEmirleri
      FIELD IsEmriId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IsEmriDetayId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD IsEmriNo AS CHARACTER FORMAT "X(32)":U
      FIELD ReceteId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD MalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD MalzemeKodu AS CHARACTER /*FORMAT "X(127)":U*/ 
      FIELD MalzemeAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD BirimId AS INTEGER
      FIELD BirimKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD PlanlananMiktar AS DECIMAL
      FIELD UretilenMiktar AS DECIMAL
      FIELD UretilenNetMiktar AS DECIMAL
      FIELD FireMiktari AS DECIMAL
      FIELD TransferEdilebilecekMiktari AS DECIMAL
      FIELD IstasyonId AS INTEGER
      FIELD IstasyonKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IstasyonAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD RotaId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD RotaKod AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD OperasyonId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
      FIELD OperasyonNo AS INTEGER
      FIELD OperasyonKodu AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD OperasyonAdi AS CHARACTER /*FORMAT "X(127)":U*/
      FIELD IsMerkeziId AS INTEGER
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
   
DEFINE OUTPUT PARAMETER TABLE FOR V_IsEmirleri.

DEFINE INPUT PARAMETER xEmir AS CHARACTER.
DEFINE INPUT PARAMETER xKod AS CHARACTER.
DEFINE INPUT PARAMETER xAd AS CHARACTER.
DEFINE INPUT PARAMETER xistkod AS CHARACTER.
DEFINE INPUT PARAMETER xoprkod AS CHARACTER.
DEFINE INPUT PARAMETER xFason AS LOGICAL.
DEFINE INPUT PARAMETER xsirano AS INTEGER INITIAL 0.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.
DEFINE VARIABLE UretilenMiktar AS INTEGER INITIAL 0.
DEFINE VARIABLE receteId AS INTEGER INITIAL 0.

ON FIND OF erp_master OVERRIDE DO: END.
ON FIND OF erp_detay OVERRIDE DO: END.
ON FIND OF stok_kart OVERRIDE DO: END.
ON FIND OF birim OVERRIDE DO: END.
ON FIND OF is_istasyon OVERRIDE DO: END.
ON FIND OF operasyon_kart2 OVERRIDE DO: END.
ON FIND OF isemri_tip OVERRIDE DO: END.
ON FIND OF erp_detay2 OVERRIDE DO: END.
ON FIND OF erp_recete OVERRIDE DO: END.

FOR EACH erp_master WHERE erp_master.firma_kod = Firma AND
	(erp_master.isemri_durum = TRUE) AND
    (erp_master.isemri_no = xEmir) /*AND
    (erp_master.stok_kod BEGINS xKod OR xKod EQ "")*/ NO-LOCK,
    EACH erp_detay OF erp_master NO-LOCK,
    /*EACH erp_recete OF erp_master NO-LOCK,*/
    EACH stok_kart OF erp_detay NO-LOCK,
    EACH birim OF erp_detay NO-LOCK,
    EACH is_istasyon OF erp_detay NO-LOCK,
    EACH operasyon_kart2 OF erp_detay NO-LOCK,
    /*EACH is_merkezi OF erp_detay NO-LOCK,*/
    EACH isemri_tip OF erp_master NO-LOCK
    ON ERROR UNDO, RETURN ERROR:

    /*FOR EACH erp_detay2 FIELDS(operasyon_kod dmiktar) 
        WHERE erp_detay2.firma_kod = erp_master.firma_kod AND 
        erp_detay2.isemri_no = erp_master.isemri_no AND 
        erp_detay2.operasyon_kod = erp_detay.operasyon_kod NO-LOCK BREAK BY erp_detay2.operasyon_kod:
      UretilenMiktar = UretilenMiktar + erp_detay2.dmiktar.
    END.*/

    FIND FIRST erp_recete WHERE erp_recete.firma_kod = erp_master.firma_kod AND erp_recete.erp_masterno = erp_master.erp_masterno NO-LOCK NO-ERROR.

    ASSIGN receteId = IF AVAILABLE erp_recete THEN INT(RECID(erp_recete)) ELSE 0.

    /*UretilenMiktar = UretilenMiktarBul(erp_master.isemri_no, operasyon_kart2.operasyon_kod).*/
	
	CREATE V_IsEmirleri.
    ASSIGN 
		V_IsEmirleri.IsEmriId = erp_master.erp_masterno /*RECID(erp_master)*/
		V_IsEmirleri.IsEmriDetayId = RECID(erp_detay)
		V_IsEmirleri.IsEmriNo = erp_master.isemri_no
		V_IsEmirleri.ReceteId = receteId
		V_IsEmirleri.MalzemeId = RECID(stok_kart)
		V_IsEmirleri.MalzemeKodu = stok_kart.stok_kod
		V_IsEmirleri.MalzemeAdi = stok_kart.stok_ad
		V_IsEmirleri.BirimId = RECID(birim)
		V_IsEmirleri.BirimKodu = birim.birim
		V_IsEmirleri.PlanlananMiktar = erp_master.pmiktar
		V_IsEmirleri.UretilenMiktar = UretilenMiktar
		V_IsEmirleri.UretilenNetMiktar = 0
		V_IsEmirleri.FireMiktari = 0
		V_IsEmirleri.TransferEdilebilecekMiktari = 0
		V_IsEmirleri.IstasyonId = RECID(is_istasyon)
		V_IsEmirleri.IstasyonKodu = is_istasyon.istasyon_kod
		V_IsEmirleri.IstasyonAdi = is_istasyon.istasyon_ad
		V_IsEmirleri.RotaId = 0
		V_IsEmirleri.RotaKod = erp_master.rota_kod
		V_IsEmirleri.OperasyonId = RECID(operasyon_kart2)
		V_IsEmirleri.OperasyonNo = erp_detay.sira_no
		V_IsEmirleri.OperasyonKodu = operasyon_kart2.operasyon_kod
		V_IsEmirleri.OperasyonAdi = operasyon_kart2.operasyon_ad
		/*V_IsEmirleri.IsMerkeziId = RECID(is_merkezi)*/
		V_IsEmirleri.IsMerkeziKodu = erp_detay.ismer_kod
		/*V_IsEmirleri.IsMerkeziAdi = is_merkezi.ismer_ad*/
		V_IsEmirleri.Aciklama = erp_master.aciklama
		V_IsEmirleri.DigerId = 0     
		V_IsEmirleri.IsEmriTipId = RECID(isemri_tip)
		V_IsEmirleri.IsEmriTipKodu = isemri_tip.tip_kod
		V_IsEmirleri.IsEmriTipAdi = isemri_tip.tip_ad
		V_IsEmirleri.OzelKod = ""
		V_IsEmirleri.DigerKod1 = erp_master.parti_kod
		V_IsEmirleri.BaslangicTarihi = STRING(erp_master.bas_tarih, "99/99/9999")
		V_IsEmirleri.BaslangicSaat = erp_master.bas_saat
		V_IsEmirleri.BitisTarihi = STRING(erp_master.bitis_tarih, "99/99/9999")
		V_IsEmirleri.BitisSaat = erp_master.bitis_saat
		V_IsEmirleri.AcilmaTarihi = STRING(erp_master.create_date, "99/99/9999").
		
    Row_Limit = Row_Limit + 1.
    IF Row_Limit GE Limit THEN LEAVE.            

END.

ON FIND OF erp_master REVERT.
ON FIND OF erp_detay REVERT.
ON FIND OF stok_kart REVERT.
ON FIND OF birim REVERT.
ON FIND OF is_istasyon REVERT.
ON FIND OF operasyon_kart2 REVERT.
ON FIND OF isemri_tip REVERT.
ON FIND OF erp_detay2 REVERT.
ON FIND OF erp_recete REVERT.



