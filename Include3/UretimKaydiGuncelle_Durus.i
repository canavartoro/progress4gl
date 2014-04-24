

FOR EACH erp_durus WHERE erp_durus.firma_kod = erp_detay2.firma_kod AND erp_durus.erp_masterno  = erp_detay2.erp_masterno AND 
	erp_durus.erp_detayno = erp_detay2.erp_detayno AND erp_durus.erp_detayno2 = erp_detay2.erp_detayno2 ON ERROR UNDO, RETURN ERROR:

	FIND FIRST xdur_table WHERE erp_durus.durus_kod = xdur_table.durus_kod NO-ERROR.
               
	IF NOT AVAILABLE xdur_table THEN DO:
		DELETE erp_durus.
	END.
	ELSE DO:
		FIND erp_durustip WHERE erp_durustip.firma_kod = firma-kod AND
                               erp_durustip.durus_kod = xdur_table.durus_kod NO-LOCK NO-ERROR.

		IF NOT AVAILABLE erp_durustip THEN DO:
			MESSAGE "Duruþ Kodu Tanimli Degildir." VIEW-AS ALERT-BOX TITLE "H a t a...".
			RETURN ERROR.
		END.

		IF AVAILABLE erp_durustip AND NOT erp_durustip.isemri_baglanti THEN DO:
			MESSAGE "Iþemri Baglantisi Olmayan Duruþ  Kodu Girilemez." VIEW-AS ALERT-BOX TITLE "H a t a...".
			RETURN ERROR.
		END. 

		ASSIGN
			erp_durus.istasyon_kod  = erp_detay2.istasyon_kod2
			erp_durus.vardiya_kod   = erp_detay2.vardiya_kod  
			erp_durus.user_kod      = user-kod
			erp_durus.durus_kod     = xdur_table.durus_kod
			erp_durus.durus_ad      = erp_durustip.durus_ad 
			erp_durus.durus_tarih   = DATE(xdur_table.baslangic)
			erp_durus.basdurus_tarih= DATE(xdur_table.baslangic)
			erp_durus.bitdurus_tarih= DATE(xdur_table.bit_tarihi)
			erp_durus.bas_saat      = SUBSTR(TRIM(xdur_table.bas_saati),1,2) + SUBSTR(TRIM(xdur_table.bas_saati),4,2)
			erp_durus.bitis_saat    = SUBSTR(TRIM(xdur_table.bit_saati),1,2) + SUBSTR(TRIM(xdur_table.bit_saati),4,2)
			erp_durus.toplam_sure   = xdur_table.sure
			erp_durus.sira_no       = xdur_table.sirano
            erp_durus.aciklama      = xdur_table.aciklama.
			DELETE xdur_table.
	END.
END.

DEFINE VARIABLE sira-no AS INTEGER INITIAL 1.
FOR EACH xdur_table WHERE xdur_table.ukayit_no = xop_table.kayit_no ON ERROR UNDO:

	IF xdur_table.durus_kod EQ "" THEN DO:
		MESSAGE "Duruþ Kodu Boþ Geçilemez." VIEW-AS ALERT-BOX WARNING BUTTONS OK.   
		RETURN ERROR.
	END.

	FIND erp_durustip WHERE erp_durustip.firma_kod = firma-kod AND
                               erp_durustip.durus_kod = xdur_table.durus_kod NO-LOCK NO-ERROR.

	IF NOT AVAILABLE erp_durustip THEN DO:
		MESSAGE "Duruþ Kodu Tanimli Degildir." VIEW-AS ALERT-BOX TITLE "H a t a...".
		RETURN ERROR.
	END.

	IF AVAILABLE erp_durustip AND NOT erp_durustip.isemri_baglanti THEN DO:
		MESSAGE "Iþemri Baglantisi Olmayan Duruþ  Kodu Girilemez." VIEW-AS ALERT-BOX TITLE "H a t a...".
		RETURN ERROR.
	END. 
          
	bas-tarih = DATE(xdur_table.baslangic).
	CREATE erp_durus.
	ASSIGN
		erp_durus.firma_kod     = erp_detay2.firma_kod    
        erp_durus.erp_masterno  = erp_detay2.erp_masterno 
        erp_durus.erp_detayno   = erp_detay2.erp_detayno  
        erp_durus.erp_detayno2  = erp_detay2.erp_detayno2 
        erp_durus.istasyon_kod  = erp_detay2.istasyon_kod2
        erp_durus.vardiya_kod   = erp_detay2.vardiya_kod  
        erp_durus.isemri_no     = erp_detay2.isemri_no    
        erp_durus.operasyon_kod = erp_detay2.operasyon_kod
        erp_durus.user_kod      = user-kod
        erp_durus.durus_kod     = xdur_table.durus_kod
        erp_durus.durus_ad      = erp_durustip.durus_ad 
        erp_durus.durus_tarih   = DATE(xdur_table.baslangic)
        erp_durus.basdurus_tarih= DATE(xdur_table.baslangic)
        erp_durus.bitdurus_tarih= DATE(xdur_table.bit_tarihi)
        erp_durus.bas_saat      = SUBSTR(TRIM(xdur_table.bas_saati),1,2) + SUBSTR(TRIM(xdur_table.bas_saati),4,2)
        erp_durus.bitis_saat    = SUBSTR(TRIM(xdur_table.bit_saati),1,2) + SUBSTR(TRIM(xdur_table.bit_saati),4,2)
        erp_durus.toplam_sure   = xdur_table.sure
        erp_durus.sira_no       = xdur_table.sirano
        erp_durus.aciklama      = xdur_table.aciklama.
        RELEASE erp_durus.
END.
