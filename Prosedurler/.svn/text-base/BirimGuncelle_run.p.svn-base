/*
Canavar.Toro
02 Mayýs 2012 02:30 Arma Filitre 
*/

DEFINE INPUT PARAMETER MalzemeBirimId  AS INTEGER.
DEFINE INPUT PARAMETER Oran AS DECIMAL.
DEFINE INPUT PARAMETER Oran2 AS DECIMAL.
DEFINE OUTPUT PARAMETER IslemSonucu AS LOGICAL INITIAL FALSE.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR:

    FIND stok_birim WHERE RECID(stok_birim) = MalzemeBirimId EXCLUSIVE-LOCK.

    IF NOT AVAILABLE stok_birim THEN DO:
        MESSAGE "malzeme birimi bulunamadý " MalzemeBirimId VIEW-AS ALERT-BOX.
        RETURN ERROR. /*LEAVE.*/
    END.
    DISPLAY "yeni" Oran Oran2 SKIP.
    DISPLAY "mevcut" stok_birim.oran stok_birim.oran2.
    ASSIGN 
        stok_birim.oran = Oran 
        stok_birim.oran2 = Oran2.
    
    DISPLAY "Guncellendi.".
    RELEASE stok_birim.    

    IslemSonucu=TRUE.
END. /*DO END*/

