ON FIND OF epersonel OVERRIDE DO: END.

DEF TEMP-TABLE Personeller
      FIELD  PersonelId AS INTEGER
      FIELD  PersonelKod AS CHARACTER FORMAT "X(32)":U
      FIELD  PersonelAdi AS CHARACTER FORMAT "X(32)":U
      FIELD  PersonelSoyad AS CHARACTER FORMAT "X(64)":U
      FIELD  DepartmanKod AS CHARACTER FORMAT "X(32)":U
      FIELD  GorevKod AS CHARACTER FORMAT "X(32)":U
      FIELD  IsyeriKod AS CHARACTER FORMAT "X(32)":U
      FIELD  Aciklama AS CHARACTER FORMAT "X(64)":U.

          
DEFINE OUTPUT PARAMETER TABLE FOR Personeller.

DEFINE INPUT PARAMETER  xkod AS CHARACTER.
DEFINE INPUT PARAMETER  xad AS CHARACTER.
DEFINE INPUT PARAMETER  xsoyad AS CHARACTER.
DEFINE INPUT PARAMETER  xdepartman AS CHARACTER.
DEFINE INPUT PARAMETER  xgorevkod AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.
DEFINE VARIABLE Row_Limit AS INTEGER INITIAL 0.

FOR EACH epersonel
            WHERE epersonel.firma_kod=Firma  AND
                  epersonel.personel_kod BEGINS xkod  AND
                  epersonel.personel_ad  BEGINS  xad   AND
                  epersonel.personel_soyad BEGINS xsoyad AND
                  epersonel.depar_kod BEGINS xdepartman  AND
                  epersonel.gorev_kod BEGINS  xgorevkod 
            NO-LOCK ON ERROR UNDO, RETURN ERROR:
         
    CREATE Personeller.
       ASSIGN
              PersonelId = RECID(epersonel)
              PersonelKod = personel_kod
              PersonelAd = personel_ad
              PersonelSoyad = personel_soyad
              DepartmanKod = depar_kod
              GorevKod = gorev_kod
              IsyeriKod = isyeri_kod
              Aciklama =  "".

         RELEASE Personeller.
    
         Row_Limit = Row_Limit + 1.

        IF Row_Limit GE Limit THEN DO:
            LEAVE.
        END.
    

    END.

OUTPUT CLOSE.

ON FIND OF epersonel REVERT.
