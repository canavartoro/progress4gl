/*********************************************************************************
Raf hareket kaydı oluşturmak için yazılmıştır
                          < Canavar.Toro >
11 Haziran 2012 Pazartesi   01:00
                    ArmaFiltre

*********************************************************************************/


DEF TEMP-TABLE RafHareket
    FIELD GirenDepoKod AS CHARACTER FORMAT "X(8)" 
    FIELD CikanDepoKod AS CHARACTER FORMAT "X(8)"
    FIELD GirenRafKod AS CHARACTER FORMAT "X(10)"
    FIELD CikanRafKod AS CHARACTER FORMAT "X(10)"
    FIELD StokKod AS CHARACTER FORMAT "X(25)"
    FIELD RenkKod AS CHARACTER FORMAT "X(20)"
    FIELD Birim AS CHARACTER FORMAT "X(8)"
    FIELD Miktar AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99<<<"
    FIELD PartiKod AS CHARACTER FORMAT "X(20)"
    FIELD Aciklama AS CHARACTER FORMAT "X(20)".  

/***************   giriş parametreleri   ************************/

DEFINE INPUT PARAMETER FirmaKod AS CHARACTER FORMAT "X(8)".
DEFINE INPUT PARAMETER Kullanici AS CHARACTER FORMAT "X(12)".

DEFINE INPUT PARAMETER GirenDepoKod AS CHARACTER FORMAT "X(8)".
DEFINE INPUT PARAMETER CikanDepoKod AS CHARACTER FORMAT "X(8)".

DEFINE INPUT PARAMETER BelgeNo AS CHARACTER FORMAT "X(12)".    
DEFINE INPUT PARAMETER BelgeTarih AS CHARACTER FORMAT "X(10)".

DEFINE DATASET RafHareketDS FOR RafHareket.
DEFINE INPUT PARAMETER DATASET FOR RafHareketDS. 

DEFINE OUTPUT PARAMETER MasterNo AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER DetaySatir AS INTEGER INITIAL 0.
DEFINE OUTPUT PARAMETER IslemSonucu AS CHARACTER INITIAL "".


{Include3\Baglanti.i}


RUN RafHareket_run.r (
    INPUT FirmaKod, INPUT Kullanici,
    INPUT GirenDepoKod, INPUT CikanDepoKod, INPUT BelgeNo, 
    INPUT BelgeTarih, INPUT TABLE RafHareket, 
    OUTPUT MasterNo, OUTPUT DetaySatir, OUTPUT IslemSonucu).


