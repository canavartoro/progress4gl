/*
Elterminalinden login olmak icin
*/
ON FIND OF firma OVERRIDE DO: END.

{INCLUDE2\degisken.i &YENI="NEW GLOBAL"}
{INCLUDE2\sontarih.i &YENI="NEW GLOBAL"}
{INCLUDE2\kartyetki.i &YENI="NEW GLOBAL"}

DEFINE INPUT PARAMETER FirmaKod  AS CHARACTER.
DEFINE INPUT PARAMETER Parola  AS CHARACTER.
DEFINE INPUT PARAMETER KullaniciKod  AS CHARACTER.
DEFINE INPUT PARAMETER LogDosyasi AS CHARACTER.
DEFINE OUTPUT PARAMETER islem_sonucu AS CHARACTER.

ASSIGN firma-kod = FirmaKod.
ASSIGN user-kod = KullaniciKod.


FIND uyum_user WHERE uyum_user.user_kod = KullaniciKod NO-LOCK NO-ERROR.

IF NOT AVAILABLE uyum_user THEN DO:
    islem_sonucu = "Kullanýcý Kodu Tanýmsýzdýr...".
    RETURN NO-APPLY.
END.
ELSE DO:
    IF uyum_user.sifre NE ENCODE(Parola) THEN DO:
        islem_sonucu = "Kullanýcý Kodu ile Þifre Uyuþmuyor...".
        RETURN NO-APPLY.
    END. 
END.
FIND firma WHERE firma.firma_kod EQ FirmaKod NO-LOCK NO-ERROR.
IF NOT AVAILABLE firma THEN DO:
    islem_sonucu = "Yazdýðýnýz þirket kodu bulunamadý..! " + FirmaKod.     
    RETURN NO-APPLY.
END.

islem_sonucu = "OK".
