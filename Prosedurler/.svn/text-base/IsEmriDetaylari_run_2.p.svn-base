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

IF xEmir NE "" THEN DO:
    FOR EACH erp_master WHERE erp_master.firma_kod = Firma AND
    	(erp_master.isemri_durum = TRUE) AND
        /*(erp_master.isemri_no BEGINS xEmir OR xEmir EQ "") AND*/
        (erp_master.isemri_no = xEmir) NO-LOCK,
        EACH erp_detay OF erp_master WHERE erp_detay.fason = xFason AND (erp_detay.istasyon_kod = xistkod OR xistkod EQ "") AND (erp_detay.operasyon_kod = xoprkod OR xoprkod EQ "") AND (erp_detay.sira_no = xsirano OR xsirano EQ 0) NO-LOCK,
        /*EACH erp_recete OF erp_master NO-LOCK,*/
        EACH stok_kart OF erp_detay /*USE-INDEX stok-urunt-ad*/ NO-LOCK,
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
    
        RUN IsEmriYaz (erp_master.erp_masterno, RECID(erp_detay),erp_master.isemri_no,receteId,
            RECID(stok_kart),stok_kart.stok_kod,stok_kart.stok_ad,RECID(birim),birim.birim,
            erp_master.pmiktar,UretilenMiktar,0,0,0,RECID(is_istasyon),is_istasyon.istasyon_kod,
            is_istasyon.istasyon_ad,0,erp_master.rota_kod,RECID(operasyon_kart2),erp_detay.sira_no,
            operasyon_kart2.operasyon_kod,operasyon_kart2.operasyon_ad,0,erp_detay.ismer_kod,erp_master.aciklama,
            0,RECID(isemri_tip),isemri_tip.tip_kod,isemri_tip.tip_ad,"",erp_master.parti_kod,STRING(erp_master.bas_tarih, "99/99/9999"),
            erp_master.bas_saat,STRING(erp_master.bitis_tarih, "99/99/9999"),erp_master.bitis_saat,STRING(erp_master.create_date, "99/99/9999")).   
    		
        Row_Limit = Row_Limit + 1.
        IF Row_Limit GE Limit THEN LEAVE.            
    
    END.
END.
ELSE IF xKod NE "" THEN DO:
    FOR EACH erp_master WHERE erp_master.firma_kod = Firma AND
    	(erp_master.isemri_durum = TRUE) AND        
        (erp_master.stok_kod = xKod OR xKod EQ "") NO-LOCK,
        EACH erp_detay OF erp_master WHERE erp_detay.fason = xFason AND (erp_detay.istasyon_kod = xistkod OR xistkod EQ "") AND (erp_detay.operasyon_kod = xoprkod OR xoprkod EQ "") AND (erp_detay.sira_no = xsirano OR xsirano EQ 0) NO-LOCK,
        /*EACH erp_recete OF erp_master NO-LOCK,*/
        EACH stok_kart OF erp_detay WHERE (stok_kart.stok_ad MATCHES "*" + xAd + "*" OR xAd EQ "") /*USE-INDEX stok-urunt-ad*/ NO-LOCK,
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
    
        RUN IsEmriYaz (erp_master.erp_masterno, RECID(erp_detay),erp_master.isemri_no,receteId,
            RECID(stok_kart),stok_kart.stok_kod,stok_kart.stok_ad,RECID(birim),birim.birim,
            erp_master.pmiktar,UretilenMiktar,0,0,0,RECID(is_istasyon),is_istasyon.istasyon_kod,
            is_istasyon.istasyon_ad,0,erp_master.rota_kod,RECID(operasyon_kart2),erp_detay.sira_no,
            operasyon_kart2.operasyon_kod,operasyon_kart2.operasyon_ad,0,erp_detay.ismer_kod,erp_master.aciklama,
            0,RECID(isemri_tip),isemri_tip.tip_kod,isemri_tip.tip_ad,"",erp_master.parti_kod,STRING(erp_master.bas_tarih, "99/99/9999"),
            erp_master.bas_saat,STRING(erp_master.bitis_tarih, "99/99/9999"),erp_master.bitis_saat,STRING(erp_master.create_date, "99/99/9999")).   
    		
        Row_Limit = Row_Limit + 1.
        IF Row_Limit GE Limit THEN LEAVE.            
    
    END.
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



PROCEDURE IsEmriYaz:

    DEFINE INPUT PARAMETER pIsEmriId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".
	DEFINE INPUT PARAMETER pIsEmriDetayId AS INTEGER.
	DEFINE INPUT PARAMETER pIsEmriNo AS CHARACTER.
	DEFINE INPUT PARAMETER pReceteId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".
	DEFINE INPUT PARAMETER pMalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".
	DEFINE INPUT PARAMETER pMalzemeKodu AS CHARACTER. 
	DEFINE INPUT PARAMETER pMalzemeAdi AS CHARACTER.
	DEFINE INPUT PARAMETER pBirimId AS INTEGER.
	DEFINE INPUT PARAMETER pBirimKodu AS CHARACTER.
	DEFINE INPUT PARAMETER pPlanlananMiktar AS DECIMAL.
	DEFINE INPUT PARAMETER pUretilenMiktar AS DECIMAL.
	DEFINE INPUT PARAMETER pUretilenNetMiktar AS DECIMAL.
	DEFINE INPUT PARAMETER pFireMiktari AS DECIMAL.
	DEFINE INPUT PARAMETER pTransferEdilebilecekMiktari AS DECIMAL.
	DEFINE INPUT PARAMETER pIstasyonId AS INTEGER.
	DEFINE INPUT PARAMETER pIstasyonKodu AS CHARACTER.
	DEFINE INPUT PARAMETER pIstasyonAdi AS CHARACTER.
	DEFINE INPUT PARAMETER pRotaId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".
	DEFINE INPUT PARAMETER pRotaKod AS CHARACTER.
	DEFINE INPUT PARAMETER pOperasyonId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".
	DEFINE INPUT PARAMETER pOperasyonNo AS INTEGER.
	DEFINE INPUT PARAMETER pOperasyonKodu AS CHARACTER.
	DEFINE INPUT PARAMETER pOperasyonAdi AS CHARACTER.
	DEFINE INPUT PARAMETER pIsMerkeziId AS INTEGER.
	DEFINE INPUT PARAMETER pIsMerkeziKodu AS CHARACTER.
	DEFINE INPUT PARAMETER pIsMerkeziAdi AS CHARACTER.
	DEFINE INPUT PARAMETER pAciklama AS CHARACTER.
	DEFINE INPUT PARAMETER pDigerId AS INTEGER FORMAT ">>>,>>>,>>>,>>9".     
	DEFINE INPUT PARAMETER pIsEmriTipId AS INTEGER.
	DEFINE INPUT PARAMETER pIsEmriTipKodu AS CHARACTER.
	DEFINE INPUT PARAMETER pIsEmriTipAdi AS CHARACTER.
	DEFINE INPUT PARAMETER pOzelKod AS CHARACTER.
	DEFINE INPUT PARAMETER pDigerKod1 AS CHARACTER.
	DEFINE INPUT PARAMETER pBaslangicTarihi AS CHARACTER.
	DEFINE INPUT PARAMETER pBaslangicSaat AS CHARACTER.
	DEFINE INPUT PARAMETER pBitisTarihi AS CHARACTER.
	DEFINE INPUT PARAMETER pBitisSaat AS CHARACTER.
	DEFINE INPUT PARAMETER pAcilmaTarihi AS CHARACTER.

    CREATE V_IsEmirleri.
    ASSIGN 
		V_IsEmirleri.IsEmriId = pIsEmriId
		V_IsEmirleri.IsEmriDetayId = pIsEmriDetayId
		V_IsEmirleri.IsEmriNo = pIsEmriNo
		V_IsEmirleri.ReceteId = pReceteId
		V_IsEmirleri.MalzemeId = pMalzemeId
		V_IsEmirleri.MalzemeKodu = pMalzemeKodu
		V_IsEmirleri.MalzemeAdi = pMalzemeAdi
		V_IsEmirleri.BirimId = pBirimId
		V_IsEmirleri.BirimKodu = pBirimKodu
		V_IsEmirleri.PlanlananMiktar = pPlanlananMiktar
		V_IsEmirleri.UretilenMiktar = pUretilenMiktar
		V_IsEmirleri.UretilenNetMiktar = pUretilenNetMiktar
		V_IsEmirleri.FireMiktari = pFireMiktari
		V_IsEmirleri.TransferEdilebilecekMiktari = pTransferEdilebilecekMiktari
		V_IsEmirleri.IstasyonId = pIstasyonId
		V_IsEmirleri.IstasyonKodu = pIstasyonKodu
		V_IsEmirleri.IstasyonAdi = pIstasyonAdi
		V_IsEmirleri.RotaId = pRotaId
		V_IsEmirleri.RotaKod = pRotaKod
		V_IsEmirleri.OperasyonId = pOperasyonId
		V_IsEmirleri.OperasyonNo = pOperasyonNo
		V_IsEmirleri.OperasyonKodu = pOperasyonKodu
		V_IsEmirleri.OperasyonAdi = pOperasyonAdi
		/*V_IsEmirleri.IsMerkeziId = pIsMerkeziId*/
		V_IsEmirleri.IsMerkeziKodu = pIsMerkeziKodu
		/*V_IsEmirleri.IsMerkeziAdi = pIsMerkeziAdi*/
		V_IsEmirleri.Aciklama = pAciklama
		V_IsEmirleri.DigerId = pDigerId     
		V_IsEmirleri.IsEmriTipId = pIsEmriTipId
		V_IsEmirleri.IsEmriTipKodu = pIsEmriTipKodu
		V_IsEmirleri.IsEmriTipAdi = pIsEmriTipAdi
		V_IsEmirleri.OzelKod = pOzelKod
		V_IsEmirleri.DigerKod1 = pDigerKod1
		V_IsEmirleri.BaslangicTarihi = pBaslangicTarihi
		V_IsEmirleri.BaslangicSaat = pBaslangicSaat
		V_IsEmirleri.BitisTarihi = pBitisTarihi
		V_IsEmirleri.BitisSaat = pBitisSaat
		V_IsEmirleri.AcilmaTarihi = pAcilmaTarihi.
    RELEASE V_IsEmirleri.

END PROCEDURE.

