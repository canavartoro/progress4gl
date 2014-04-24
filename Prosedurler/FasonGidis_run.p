/*
Canavar.toro
26 Temmuz 2012 15:50 Arma filtre
*/
ON FIND OF firma OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}
{Include3\Baglanti.i}

DEFINE TEMP-TABLE FasonGidis
    FIELD MalzemeKod AS CHARACTER FORMAT "X(60)"
    FIELD Miktar AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.999"
    FIELD PartiNo AS CHARACTER FORMAT "X(30)".

DEFINE INPUT PARAMETER xFirmaKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xUserKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeNo  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xDepoKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xIstasyonKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xIsEmriNo  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xOperasyonKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xPartiKod  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xBelgeTarih  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER xGonderimTamam  AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER xMiktar  AS DECIMAL NO-UNDO.
DEFINE INPUT PARAMETER xKayitId AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR FasonGidis.

DEFINE OUTPUT PARAMETER MasterNo AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER NO-UNDO.

DEFINE VARIABLE isemriStokId AS RECID NO-UNDO. 
DEFINE VARIABLE hareketKod AS CHARACTER NO-UNDO.

ASSIGN firma-kod = xFirmaKod.
ASSIGN user-kod = xUserKod.

OUTPUT TO VALUE(barset-log-dir + "fason_" + xIsEmriNo + ".txt").

DO  TRANSACTION ON ERROR UNDO, RETURN ERROR:

    DISPLAY xBelgeNo NO-LABEL xBelgeTarih NO-LABEL.

    FIND FIRST erp_detay3 WHERE erp_detay3.firma_kod = firma-kod AND erp_detay3.toplam_sure = xKayitId NO-LOCK NO-ERROR.
    IF AVAILABLE erp_detay3 THEN DO:
        IslemSonucu = "Fason cikis kaydi daha once erpye aktarilmis tekrar aktaramazsiniz:" + STRING(xKayitId).
        MESSAGE "Fason cikis kaydi daha once erpye aktarilmis tekrar aktaramazsiniz:" + STRING(xKayitId) VIEW-AS ALERT-BOX TITLE "U y a r ý...".
        RETURN ERROR.
    END.

    /*IF AVAILABLE is_istasyon AND oldu1 THEN koltuk-depo = is_istasyon.depo_kod3.
        IF AVAILABLE is_istasyon AND oldu2 THEN cikis-depo  = is_istasyon.depo_kod4.*/

    FIND uretim_param2 WHERE uretim_param2.firma_kod = firma-kod NO-LOCK NO-ERROR.                      

    FIND is_istasyon WHERE is_istasyon.firma_kod = firma-kod AND
                            is_istasyon.istasyon_kod = xIstasyonKod NO-LOCK NO-ERROR.
     IF NOT AVAILABLE is_istasyon THEN DO:
         IslemSonucu = "Girilen Ýþ Ýstasyonu Tanýmsýz...".
         MESSAGE IslemSonucu
               VIEW-AS ALERT-BOX TITLE "U y a r ý...".
               RETURN ERROR.
     END. 

     IF NOT is_istasyon.fason THEN DO:
         IslemSonucu = "Fason Olmayan Bir Ýþ Ýstasyonu Seçemezsiniz...".
         MESSAGE IslemSonucu
             VIEW-AS ALERT-BOX TITLE "U y a r ý...".
             RETURN ERROR.
     END.

     IF is_istasyon.cari_kod EQ "" THEN DO:
         IslemSonucu = "Fason Istasyonun Cari bilgisi tanimi degil...".
         MESSAGE IslemSonucu
             VIEW-AS ALERT-BOX TITLE "U y a r ý...".
             RETURN ERROR.
     END.

     IF NOT AVAILABLE uretim_param2 THEN DO:
         ASSIGN hareketKod = uretim_param2.ham_hareket.           
     END.

     IF hareketKod EQ "" THEN ASSIGN hareketKod = is_istasyon.uretim_hareket2.
     IF hareketKod EQ "" THEN DO:
         IslemSonucu = "Fason Hareket Kodu Bulunamadý." +
            "Üretim Parametreleri veya Ýþ Ýstasyon Tanýmýnda, Transfer Þeklinde Bir Fason Hareketi Tanýtýnýz." +
            "(entegre-yap)".
         MESSAGE IslemSonucu VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Hata".
         RETURN ERROR.
     END.

     FIND erp_master WHERE erp_master.firma_kod = firma-kod AND
                           erp_master.isemri_no = xIsEmriNo NO-LOCK NO-ERROR.

     IF NOT AVAILABLE erp_master THEN DO:
         IslemSonucu = "Ýþemri Kaydý Bulunamadý... Ýþemri No:" + xIsEmriNo.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX.
        RETURN ERROR.        
     END.

     FIND FIRST erp_detay WHERE erp_detay.firma_kod     = erp_master.firma_kod AND
                                erp_detay.erp_masterno  = erp_master.erp_masterno AND
                                erp_detay.operasyon_kod = xOperasyonKod NO-LOCK NO-ERROR.
     IF NOT AVAILABLE erp_detay THEN DO:
         IslemSonucu = "Ýþemri Operasyon Detay Kaydý Bulunamadý..." +
                "Ýþemri No:" + xIsEmriNo +
                "Operasyon Kodu:" + xOperasyonKod.
        MESSAGE IslemSonucu VIEW-AS ALERT-BOX.
        RETURN ERROR.
     END.

     FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND 
                             stok_kart.stok_kod  = erp_master.stok_kod NO-LOCK NO-ERROR.

     CREATE erp_detay3.
         ASSIGN 
             erp_detay3.firma_kod      = firma-kod
             erp_detay3.kaynak_prog    = 'Fason'
             erp_detay3.giris_cikis    = FALSE 
             erp_detay3.entegre_yap    = FALSE
             erp_detay3.operasyon_kod  = xOperasyonKod
             erp_detay3.istasyon_kod   = xIstasyonKod
             erp_detay3.cari_kod       = is_istasyon.cari_kod
             erp_detay3.depo_kod       = is_istasyon.depo_kod
             erp_detay3.depo_kod2      = xDepoKod /*is_istasyon.depo_kod4*/
             erp_detay3.isemri_no      = xIsEmriNo
             erp_detay3.stok_kod       = stok_kart.stok_kod
             erp_detay3.bitis_tarih    = DATE(xBelgeTarih)
             erp_detay3.sira_no        = erp_detay.sira_no
             erp_detay3.aciklama       = "Mikrobar Tarafýndan Oluþturuldu."
             erp_detay3.ham_tamam      = xGonderimTamam
             erp_detay3.dmiktar        = xMiktar
             erp_detay3.hareket_miktar = xMiktar
             erp_detay3.dbirim         = stok_kart.birim
             erp_detay3.parti_kod      = xPartiKod
             erp_detay3.belge_no       = xBelgeNo
             erp_detay3.toplam_sure    = xKayitId
             /*erp_detay3.toplam_sure    = xfason_gidis.belge_saat)*/
             /*erp_detay3.hareket_miktar = xfason_gidis.hareket_miktar*/
             isemriStokId = RECID(erp_detay3).
             RELEASE erp_detay3.             

    FIND erp_detay3 WHERE RECID(erp_detay3) = isemriStokId EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                 
    CREATE stok_master. 
        ASSIGN  
            stok_master.firma_kod       = erp_master.firma_kod
            stok_master.belge_no        = STRING(erp_detay3.isemri_no)
            stok_master.belge_tarih     = erp_detay3.bitis_tarih
            stok_master.hareket_kod     = hareketKod
            stok_master.cari_kod        = erp_detay3.cari_kod
            stok_master.depo_kod        = erp_detay3.depo_kod2
            stok_master.diger_depo      = erp_detay3.depo_kod
            stok_master.stok_masterno   = NEXT-VALUE(master-kayit-no)
            stok_master.aciklama        = "Fason'a Malzeme Çýkýþý"
            stok_master.aciklama2       = erp_detay3.isemri_no + " Nolu Ýþemri Ýçin..."
            stok_master.kaynak_prog     = 'Fason'
            stok_master.kaynak_prog2    = 'Fason'
            stok_master.kaynak_prog3    = 'Fason'
            stok_master.kaynak_masterno = erp_detay3.erp_detayno3
            stok_master.user_kod        = user-kod.                                 
            isemriStokId = RECID(stok_master).
            RELEASE stok_master.

    FIND stok_master WHERE RECID(stok_master) = isemriStokId EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

    ASSIGN 
        erp_detay3.stok_masterno2 = stok_master.stok_masterno
        MasterNo = stok_master.stok_masterno.
    /*FOR EACH erp_recete WHERE erp_recete.firma_kod            = firma-kod AND
                                         erp_recete.erp_masterno         = erp_master.erp_masterno AND
                                         erp_recete.operasyon_kod        = xOperasyonKod NO-LOCK ON ERROR UNDO, RETURN ERROR:*/

    FOR EACH FasonGidis NO-LOCK ON ERROR UNDO, RETURN ERROR:

        FIND erp_recete WHERE erp_recete.firma_kod = firma-kod AND 
            erp_recete.erp_masterno = erp_master.erp_masterno AND erp_recete.operasyon_kod = xOperasyonKod AND
            erp_recete.stok_kod = FasonGidis.MalzemeKod NO-LOCK NO-ERROR.

        IF NOT AVAILABLE erp_recete THEN DO:
            MESSAGE "Ýþemri Recete Detay Kaydý Bulunamadý..." SKIP
                "Ýþemri No:" xIsEmriNo SKIP
                "Stok Kodu:" FasonGidis.MalzemeKod VIEW-AS ALERT-BOX.
            RETURN ERROR.
        END.

        FIND stok_kart WHERE stok_kart.firma_kod = firma-kod AND 
                             stok_kart.stok_kod  = erp_recete.stok_kod NO-LOCK NO-ERROR.

        CREATE stok_hareket.
                     ASSIGN 
                            stok_hareket.firma_kod       = erp_master.firma_kod                                                    
                            stok_hareket.belge_no        = STRING(erp_detay3.isemri_no)                                                                                                      
                            stok_hareket.belge_tarih     = DATE(erp_detay3.bitis_tarih)                                                                                                        
                            stok_hareket.hareket_kod     = hareketKod                                      
                            stok_hareket.kaynak_prog     = 'Fason'                                           
                            stok_hareket.kaynak_prog3    = 'Fason'                                           
                            stok_hareket.kaynak_masterno = 999                                               
                            stok_hareket.kaynak_detayno  = erp_detay3.erp_detayno3                           
                            stok_hareket.cari_kod        = erp_detay3.cari_kod                               
                            stok_hareket.parti_kod       = FasonGidis.PartiNo                              
                            stok_hareket.renk_no         = erp_detay.renk_no                                
                            stok_hareket.stok_masterno   = stok_master.stok_masterno                         
                            stok_hareket.stok_detayno    = NEXT-VALUE(detay-kayit-no)                        
                            stok_hareket.depo_kod        = stok_master.depo_kod
                            stok_hareket.diger_depo      = stok_master.diger_depo                           
                            stok_hareket.dmiktar         = FasonGidis.Miktar    
                            stok_hareket.hareket_miktar  = FasonGidis.Miktar   
                            stok_hareket.dbirim          = stok_kart.birim                                 
                          /*stok_hareket.dfiyat          = stok_kart.birimfiyat   */
                          /*stok_hareket.dtutar          = erp_recete.dbirim * stok_kart.dfiyat
                            stok_hareket.hareket_tutar   = erp_recete.dbirim * stok_kart.dfiyat*/
                            stok_hareket.stok_kod        = stok_kart.stok_kod                              
                            stok_hareket.stok_ad         = stok_kart.stok_ad
                            stok_hareket.recete_kod      = erp_recete.recete_kod
                            stok_hareket.user_kod        = user-kod.
                     DetaySatir = DetaySatir + 1.
    END.

END.


OUTPUT CLOSE.

ON FIND OF firma REVERT.
