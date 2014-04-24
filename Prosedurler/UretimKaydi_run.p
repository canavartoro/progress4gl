ON FIND OF erp_detay2  OVERRIDE DO: END.
ON FIND OF erp_durustip  OVERRIDE DO: END.
ON FIND OF erp_master  OVERRIDE DO: END.
ON FIND OF erp_detay  OVERRIDE DO: END.
ON FIND OF isemri_tip  OVERRIDE DO: END.
ON WRITE OF erp_durus  OVERRIDE DO: END.
ON WRITE OF ham_detay  OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEF TEMP-TABLE xop_table
            FIELD kayit_no        AS CHARACTER 
            FIELD isemri_no       AS CHARACTER 
            FIELD operasyon_kod   AS CHARACTER 
            FIELD istasyon_kod    AS CHARACTER 
            FIELD bas_tarihi      AS CHARACTER
            FIELD bas_saati       AS CHARACTER
            FIELD bit_tarihi      AS CHARACTER            
            FIELD bit_saati       AS CHARACTER
            FIELD miktar          AS DECIMAL 
            FIELD kat_sayi        AS DECIMAL 
            FIELD kat_sayi2       AS DECIMAL
            FIELD vardiya_kod     AS CHARACTER
            FIELD skk_no          AS CHARACTER
            FIELD aciklama1       AS CHARACTER
            FIELD aciklama2       AS CHARACTER
            FIELD aciklama3       AS CHARACTER
            FIELD aciklama4       AS CHARACTER
            FIELD aciklama5       AS CHARACTER
            FIELD aciklama6       AS CHARACTER.

DEF TEMP-TABLE xis_table
            FIELD ukayit_no     AS CHARACTER
            FIELD personel_kod  AS CHARACTER
			FIELD bas_tarihi    AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER
            FIELD aciklama      AS CHARACTER.

DEF TEMP-TABLE xdur_table
            FIELD ukayit_no     AS CHARACTER
            FIELD durus_kod     AS CHARACTER
            FIELD tezgah_kod    AS CHARACTER
            FIELD baslangic     AS CHARACTER
            FIELD bas_saati     AS CHARACTER
            FIELD bit_tarihi    AS CHARACTER            
            FIELD bit_saati     AS CHARACTER
            FIELD aciklama      AS CHARACTER
            FIELD sure          AS INT
            FIELD sirano        AS INT.

DEF TEMP-TABLE xhur_table
            FIELD ukayit_no     AS CHARACTER
            FIELD hurda_skod    AS CHARACTER
            FIELD hurda_sbirim  AS CHARACTER
            FIELD hurda_kod     AS CHARACTER
            FIELD aciklama     AS CHARACTER
            FIELD diger_depo    AS CHARACTER
            FIELD parti_kod    AS CHARACTER
            FIELD miktar        AS DECIMAL.

DEF TEMP-TABLE xalet_table
            FIELD ukayit_no     AS CHARACTER
            FIELD platform_kod    AS CHARACTER
            FIELD platform_ad    AS CHARACTER.

DEFINE TEMP-TABLE Malzemeler
    FIELD Alternatif AS LOGICAL 
    FIELD DepoKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod AS CHARACTER FORMAT "X(30)"
    FIELD MalzemeKod2 AS CHARACTER FORMAT "X(30)"
    FIELD Birim AS CHARACTER FORMAT "X(10)"
    FIELD KMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99999" DECIMALS 2
    FIELD FMiktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)"
    FIELD MiktarSekli AS INTEGER.

    /***************   local variable   ************************/

DEF VAR psure AS DEC.
DEF VAR x5recid AS RECID.
DEF VAR xfile-line AS CHARACTER.
DEF BUFFER ydetay FOR erp_detay2.
DEF VAR bas-tarih AS DATE FORMAT "99/99/99".
DEF VAR hur-miktar LIKE erp_detay2.hurda_miktar.
DEF VAR kayit-id LIKE erp_detay2.kayit_id FORMAT "X(25)" INITIAL "".

/***************   giris parametreleri   ************************/

DEFINE INPUT PARAMETER fkod  AS CHARACTER.
DEFINE INPUT PARAMETER ukod  AS CHARACTER.
DEFINE INPUT PARAMETER logfile AS CHARACTER.
DEFINE INPUT PARAMETER partikod AS CHARACTER.

DEFINE INPUT PARAMETER TABLE FOR xop_table. 
DEFINE INPUT PARAMETER TABLE FOR xis_table. 
DEFINE INPUT PARAMETER TABLE FOR xdur_table. 
DEFINE INPUT PARAMETER TABLE FOR xhur_table.
DEFINE INPUT PARAMETER TABLE FOR xalet_table.
DEFINE INPUT PARAMETER TABLE FOR Malzemeler.

DEFINE OUTPUT PARAMETER master_no AS DECIMAL.
DEFINE OUTPUT PARAMETER detay_satir AS INT.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

 

/*C:\OpenEdge\barset\Include2\repmas.i*/
ASSIGN firma-kod = fkod.
ASSIGN user-kod = ukod.

OUTPUT TO VALUE(barset-log-dir + logfile + ".txt").

FOR EACH xop_table ON ERROR UNDO, RETURN ERROR:
    FIND erp_master WHERE erp_master.firma_kod = firma-kod AND erp_master.isemri_no = xop_table.isemri_no NO-LOCK NO-ERROR.
   
    IF NOT AVAILABLE erp_master THEN DO:         
        MESSAGE "Ýþ Emri Bulunamadý... Ýþ Emri No : " xop_table.isemri_no VIEW-AS ALERT-BOX TITLE "U y a r ý...".       
        RETURN ERROR.          
    END.

    /*OKUTULMAYAN MALZEMELER ERP RECETEDEN CIKARTILIYOR*/
	FOR EACH erp_recete WHERE erp_recete.firma_kod = firma-kod 
		AND erp_recete.erp_masterno = erp_master.erp_masterno AND erp_recete.operasyon_kod = xop_table.operasyon_kod:
		
		FIND FIRST Malzemeler WHERE Malzemeler.MalzemeKod = erp_recete.stok_kod NO-LOCK NO-ERROR.
	
		IF NOT AVAILABLE Malzemeler THEN DO:
			FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND stok_kart.stok_kod = erp_recete.stok_kod NO-LOCK NO-ERROR.
			IF NOT AVAILABLE stok_kart THEN DO:
				MESSAGE "Stok kart bilgisi Bulunamadý... Stok kodu : " erp_recete.stok_kod VIEW-AS ALERT-BOX TITLE "U y a r ý...".      
				RETURN ERROR.
			END.
			IF stok_kart.int_sira NE 2 THEN DO:
				MESSAGE "Is Emri malzeme listesinde zorunlu olan malzeme var... (" stok_kart.int_sira ") Stok kodu : " erp_recete.stok_kod  VIEW-AS ALERT-BOX TITLE "U y a r ý...".      
				RETURN ERROR.
			END.
			DELETE erp_recete.
		END.  
	END.
END.


ISLEM-BLOK:
REPEAT:
        
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR:        
        
        FOR EACH xop_table ON ERROR UNDO, RETURN ERROR:

            FIND erp_detay2 WHERE erp_detay2.firma_kod = firma-kod AND erp_detay2.kayit_id = xop_table.kayit_no NO-LOCK NO-ERROR.
            IF  AVAILABLE erp_detay2 THEN DO:   /*ayni kayit daha once aktarilmis demektir*/    
                MESSAGE "Uretim kaydi daha once erpye aktarilmis! " xop_table.kayit_no "(erp_detay2)" VIEW-AS ALERT-BOX TITLE "Hata!".        
                RETURN ERROR.
            END.
            
            FIND is_istasyon WHERE is_istasyon.firma_kod = firma-kod AND is_istasyon.istasyon_kod = xop_table.istasyon_kod NO-LOCK NO-ERROR.
                
            IF NOT AVAILABLE is_istasyon THEN DO:
                MESSAGE "Ýstasyon Kodu Bulunamadý... Ýþ Emri No   : " xop_table.isemri_no "Ýstasyon Kod : " xop_table.istasyon_kod VIEW-AS ALERT-BOX TITLE "U y a r ý...".
                RETURN ERROR.
            END.
   
            IF NOT AVAILABLE is_istasyon THEN NEXT.
                FIND erp_master WHERE erp_master.firma_kod = firma-kod AND erp_master.isemri_no = xop_table.isemri_no NO-LOCK NO-ERROR.
   
                IF NOT AVAILABLE erp_master THEN DO: 
                    MESSAGE firma-kod.
                    MESSAGE "Ýþ Emri Bulunamadý... Ýþ Emri No : " xop_table.isemri_no VIEW-AS ALERT-BOX TITLE "U y a r ý...".       
                    RETURN ERROR.          
                END.
   
                IF NOT AVAILABLE erp_master THEN RETURN ERROR.
   
                FIND LAST erp_detay WHERE erp_detay.firma_kod = firma-kod AND erp_detay.erp_masterno = erp_master.erp_masterno AND erp_detay.operasyon_kod = xop_table.operasyon_kod NO-LOCK NO-ERROR.
   
                IF NOT AVAILABLE erp_detay THEN DO:       
                    MESSAGE "Ýþ Emri/Operasyon Bulunamadý... Ýþ Emri No : " xop_table.isemri_no "Operasyon  : " xop_table.operasyon_kod VIEW-AS ALERT-BOX TITLE "U y a r ý...".      
                    RETURN ERROR.
                END.
  
   
                IF NOT AVAILABLE erp_detay THEN DO:       
                    MESSAGE "IS EMRI BILGISI BULUNAMADI! (erp_detay)" VIEW-AS ALERT-BOX.       
                    NEXT.
                END.                
  
   
                IF xop_table.bit_tarihi = ? THEN NEXT.
                
                IF is_istasyon.fason THEN NEXT.
        
                kayit-id = kayit-id + xop_table.kayit_no.
        
                CREATE erp_detay2.        
                ASSIGN           
                    erp_detay2.birim          = erp_detay.birim
                    erp_detay2.bas_tarih      = DATE(xop_table.bas_tarih)
                    erp_detay2.bitis_tarih    = DATE(xop_table.bit_tarih)
                    erp_detay2.bas_zaman2     = SUBSTR(TRIM(xop_table.bas_saat),1,2) + SUBSTR(TRIM(xop_table.bas_saat),4,2)
                    erp_detay2.bitis_zaman2   = SUBSTR(TRIM(xop_table.bit_saat),1,2) + SUBSTR(TRIM(xop_table.bit_saat),4,2)
                    erp_detay2.dbirim         = erp_detay.dbirim
                    erp_detay2.erp_detayno    = erp_detay.erp_detayno
                    erp_detay2.erp_detayno2   = NEXT-VALUE(detay-kayit-no)
                    erp_detay2.erp_masterno   = erp_detay.erp_masterno
                    erp_detay2.firma_kod      = firma-kod
                    erp_detay2.burut_miktar   = xop_table.miktar
                    /*erp_detay2.dmiktar      = xop_table.miktar*/
                    erp_detay2.kaynak_prog    = 'Uyum'
                    erp_detay2.hammadde_tuket = TRUE
                    erp_detay2.user_kod       = user-kod
                    erp_detay2.parti_kod      = partikod /*erp_master.parti_kod*/
                    erp_detay2.kayit_id       = xop_table.kayit_no
                    erp_detay2.renk_no        = erp_master.renk_no
                    erp_detay2.istasyon_kod2  = xop_table.istasyon_kod
                    erp_detay2.isemri_no      = erp_detay.isemri_no
                    erp_detay2.istasyon_kod   = erp_detay.istasyon_kod
                    erp_detay2.operasyon_kod  = xop_table.operasyon_kod
                    erp_detay2.parti_kod      = partikod /*erp_detay.parti_kod*/
                    erp_detay2.sira_no        = erp_detay.sira_no 
                    erp_detay2.aciklama1      = "Mikrobar Tarafýndan Oluþturuldu."
                    erp_detay2.aciklama2      = xop_table.aciklama1
                    erp_detay2.aciklama3      = xop_table.aciklama2
                    erp_detay2.aciklama4      = xop_table.aciklama3
                    erp_detay2.aciklama5      = xop_table.aciklama4
                    erp_detay2.aciklama6      = xop_table.aciklama5
                    erp_detay2.aciklama7      = xop_table.aciklama6
                    /*erp_detay2.maliyet_katsayi= IF xop_table.kat_sayi EQ 0 THEN is_istasyon.maliyet_katsayi ELSE xop_table.kat_sayi 
                    erp_detay2.maliyet_katsayi2= is_istasyon.maliyet_katsayi2*/
                    erp_detay2.vardiya_kod    = xop_table.vardiya_kod.
                    IF  xop_table.skk_no NE "" THEN DO:
                        erp_detay2.skk_no    = xop_table.skk_no.
                    END.
                    IF xop_table.kat_sayi > 0 THEN DO:
                        ASSIGN
                        erp_detay2.maliyet_katsayi = xop_table.kat_sayi
                        erp_detay2.maliyet_katsayi2= xop_table.kat_sayi2.
                    END. ELSE DO:
                        ASSIGN
                        erp_detay2.maliyet_katsayi = is_istasyon.maliyet_katsayi
                        erp_detay2.maliyet_katsayi2= is_istasyon.maliyet_katsayi2.
                    END.
                    /*erp_detay2.hurda_miktar = hur-miktar. */
                    /*erp_detay2.entegre_yap  = TRUE.*/
                     master_no = erp_detay.erp_masterno.
					 
                     detay_satir = detay_satir + 1.

                     /***************************Süre Hesapla*****************************************************************/       
            
                     psure = 2.                     
            
                     IF xop_table.bit_saati NE "" AND xop_table.bas_saati NE "" THEN DO:
                         psure = ((INT(SUBSTR(TRIM(xop_table.bit_saati),1,2)) * 60 * 60 + INT(SUBSTR(TRIM(xop_table.bit_saati),4,2)) * 60) - (INT(SUBSTR(TRIM(xop_table.bas_saati),1,2))   * 60 * 60 + INT(SUBSTR(TRIM(xop_table.bas_saati),4,2))   * 60)) / 60. 
                         psure = psure + (DATE(xop_table.bit_tarihi) - DATE(xop_table.bas_tarihi)) * 1440.                  
                         IF psure EQ ? THEN psure = 2.                
                         /*DISP psure @ xisemri_operasyon.toplam_sure WITH FRAME frame-a NO-ERROR.*/                
                         IF psure < 1 THEN psure = 2.                
                         IF psure EQ ? THEN psure = 2.                
                         /*DISP psure @ xisemri_operasyon.toplam_sure WITH FRAME frame-a NO-ERROR.*/            
                     END. /* ne*/

                     /*DISPLAY xop_table.bas_tarihi xop_table.bas_saati xop_table.bit_tarihi xop_table.bit_saati psure.*/
            
                     /********************************************************************************************************/  

                     IF INT(psure) LE 1 THEN psure = 2.

            
                     erp_detay2.toplam_sure    = psure.                      
                     erp_detay2.entegre_yap    = TRUE.                       
                     x5recid = RECID(erp_detay2).                       
                     RELEASE erp_detay2.                                                                               
                     /*xisemri_operasyon.aktarim       = TRUE.*/ /*ASSIGN  deger = TRUE.*/                    
                     /********************************************************************************************************/                 
                     /*xisemri_operasyon.aktarim       = TRUE.*/ /*ASSIGN  deger = TRUE.*/

                     FIND erp_detay2 WHERE RECID(erp_detay2) = x5recid EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    
                     IF  NOT AVAILABLE erp_detay2 THEN DO:        
                         MESSAGE "Ýþ emri bilgilerinde hata var! " SKIP "(erp_detay2)" VIEW-AS ALERT-BOX TITLE "Hata!".        
                         RETURN ERROR.
                     END.
            /*DISPLAY "iscilik".*/
           FOR EACH xis_table WHERE  xis_table.ukayit_no = xop_table.kayit_no ON ERROR UNDO, RETURN ERROR:

               CREATE erp_iscilik.
                   ASSIGN 
                       erp_iscilik.firma_kod     = erp_detay2.firma_kod 
                       erp_iscilik.erp_masterno  = erp_detay2.erp_masterno
                       erp_iscilik.erp_detayno   = erp_detay2.erp_detayno
                       erp_iscilik.erp_detayno2  = erp_detay2.erp_detayno2
                       erp_iscilik.bas_zaman     = REPLACE(xis_table.bas_saati, ":", "")  
                       erp_iscilik.bitis_zaman   = REPLACE(xis_table.bit_saati, ":", "")
                       erp_iscilik.bas_tarih     = erp_detay2.bas_tarih
                       erp_iscilik.calisma_tarih = erp_detay2.bitis_tarih
                       erp_iscilik.personel_kod  = xis_table.personel_kod.

           END.

           /*DISPLAY "durus".*/
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
          
                 CREATE erp_durus.
                 bas-tarih = DATE(xdur_table.baslangic).
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
                    erp_durus.sira_no       = xdur_table.sirano. 
                 RELEASE erp_durus.
           END.

           /*DISPLAY "kalip".*/
           FOR EACH xalet_table ON ERROR UNDO, RETURN ERROR:

               CREATE erp_kalip.
               ASSIGN 
                   erp_kalip.firma_kod = erp_detay2.firma_kod
                   erp_kalip.erp_masterno = erp_detay2.erp_masterno
                   erp_kalip.erp_detayno = erp_detay2.erp_detayno
                   erp_kalip.erp_detayno2 = erp_detay2.erp_detayno2
                   erp_kalip.platform_kod = xalet_table.platform_kod
                   erp_kalip.platform_ad = xalet_table.platform_ad.
               RELEASE erp_kalip.

           END.

           /*DISPLAY "hurda".*/
           FOR EACH  xhur_table ON ERROR UNDO, RETURN ERROR:  

               IF xhur_table.hurda_kod EQ "" THEN DO:
                   MESSAGE "Hurda Nedeni Boþ Geçilemez." VIEW-AS ALERT-BOX WARNING BUTTONS OK.
                   RETURN ERROR.
               END.

               FIND hurda_tip WHERE hurda_tip.firma_kod = firma-kod AND hurda_tip.hurda_kod = xhur_table.hurda_kod NO-LOCK NO-ERROR.

               IF NOT AVAILABLE hurda_tip THEN DO:
                   MESSAGE "Hurda Nedeni Tanýmlý Deðildir." xhur_table.hurda_kod SKIP VIEW-AS ALERT-BOX TITLE "H a t a...".
                   RETURN ERROR.
               END.  

               IF AVAIL erp_detay2 THEN DO:
                  CREATE hurda_detay.
                      ASSIGN                   
                          hurda_detay.firma_kod     = erp_detay2.firma_kod          
                          hurda_detay.erp_masterno  = erp_detay2.erp_masterno   
                          hurda_detay.erp_detayno   = erp_detay2.erp_detayno    
                          hurda_detay.erp_detayno2  = erp_detay2.erp_detayno2   
                          hurda_detay.istasyon_kod  = erp_detay2.istasyon_kod2  
                          hurda_detay.isemri_no     = erp_detay2.isemri_no      
                          hurda_detay.operasyon_kod = erp_detay2.operasyon_kod
                          hurda_detay.stok_kod      = xhur_table.hurda_skod
                        /*hurda_detay.dbirim        = erp_detay2.dbirim*/
                          hurda_detay.dbirim        = xhur_table.hurda_sbirim
                          hurda_detay.depo_kod      = erp_detay2.depo_kod
                          hurda_detay.dmiktar       = xhur_table.miktar
                          hurda_detay.hurda_kod     = xhur_table.hurda_kod
                          hurda_detay.aciklama      = xhur_table.aciklama
                          hurda_detay.parti_kod     = xhur_table.parti_kod
                          hurda_detay.diger_depo    = xhur_table.diger_depo.
                          
              END.

              FIND ydetay WHERE ydetay.firma_kod = erp_detay2.firma_kod AND ydetay.erp_masterno = erp_detay2.erp_masterno AND ydetay.erp_detayno = erp_detay2.erp_detayno AND ydetay.erp_detayno2 = erp_detay2.erp_detayno2 NO-ERROR.
              FIND ham_detay WHERE ham_detay.firma_kod = firma-kod AND ham_detay.ham_masterno = erp_detay2.ham_masterno AND ham_detay.ham_detayno = hurda_detay.hurda_detayno AND ham_detay.stok_kod = hurda_detay.stok_kod NO-ERROR.

              IF AVAILABLE ham_detay THEN DO:
                  ON DELETE OF ham_detay OVERRIDE DO: END.
                  DELETE ham_detay.
                  hurda_detay.artirma = FALSE.
              END.

              ASSIGN 
                  ydetay.hurda_miktar  = 0
                  ydetay.hurda_miktar2 = 0
                  ydetay.entegre_yap   = FALSE.
              IF AVAILABLE ydetay THEN ydetay.entegre_yap = TRUE.
              RELEASE ydetay.                                                    

           END.

            IF AVAILABLE erp_detay2 THEN DO:
                    ASSIGN 
                      erp_detay2.entegre_yap    = TRUE.
            END. 
            RELEASE erp_detay2.
            RUN UretimMalzemeleri (INPUT x5recid, INPUT TABLE Malzemeler).

END. /* xisemri_operasyon */     
    
END.  /*END TRAN */

master_no = DEC(x5recid).

  
LEAVE ISLEM-BLOK.
END. /* END ISLEM-BLOK */

DISPLAY "Islem sonucu:" STRING(detay_satir) NO-LABEL " Satir, Master No:" STRING(x5recid) NO-LABEL ", Kayit No:" kayit-id NO-LABEL ", Bilgi:" REPLACE(STRING(TIME,'HH:MM:SS'),":","").

OUTPUT CLOSE.

ON FIND OF erp_detay2  REVERT.
ON FIND OF erp_durustip  REVERT.
ON FIND OF erp_master  REVERT.
ON FIND OF erp_detay  REVERT.
ON FIND OF isemri_tip  REVERT.
ON WRITE OF erp_durus  REVERT.
ON WRITE OF ham_detay  REVERT.

/*
INPUT FROM VALUE(SEARCH(xlog-file)) NO-ECHO.
  REPEAT:
  IMPORT UNFORMATTED xfile-line.
  SET islem_sonucu = islem_sonucu + xfile-line.
  END.
INPUT CLOSE.*/


/*OS-DELETE VALUE("C:\webo" + belgeno + ".txt") NO-ERROR.*/



