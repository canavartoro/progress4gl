
{Include3\Baglanti.i}

/***************   local variable   ************************/

DEF VAR xfile-line AS CHARACTER NO-UNDO.

/***************   giriþ parametreleri   ************************/

DEFINE INPUT PARAMETER bno AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER okunan AS CHARACTER NO-UNDO.

/***************   giriþ parametreleri   ************************/


basla:
REPEAT:

IF SEARCH(barset-log-dir + bno + ".txt") = ? THEN DO: 
    MESSAGE "Dosya bulunamadi"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    LEAVE basla.
END.

INPUT FROM VALUE(SEARCH(barset-log-dir + bno + ".txt") ) NO-ECHO.
  REPEAT:
    IMPORT UNFORMATTED xfile-line.
    SET okunan=okunan + xfile-line.
  END.
INPUT CLOSE.

LEAVE basla.
END.


