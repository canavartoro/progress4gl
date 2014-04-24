

DEFINE VARIABLE bas_saati AS CHARACTER FORMAT "X(5)" INITIAL "17:27" NO-UNDO.
DEFINE VARIABLE bit_saati AS CHARACTER FORMAT "X(5)" INITIAL "15:06" NO-UNDO.
DEFINE VARIABLE bas_tarihi AS CHARACTER FORMAT "X(10)" INITIAL "31.01.2014" NO-UNDO.
DEFINE VARIABLE bit_tarihi AS CHARACTER FORMAT "X(10)" INITIAL "03.02.2014" NO-UNDO.
DEFINE VARIABLE psure AS INTEGER INITIAL 0 NO-UNDO.


IF bit_saati NE "" AND bas_saati NE "" THEN DO:
    psure = ((INT(SUBSTR(TRIM(bit_saati),1,2)) * 60 * 60 + INT(SUBSTR(TRIM(bit_saati),4,2)) * 60) - (INT(SUBSTR(TRIM(bas_saati),1,2))   * 60 * 60 + INT(SUBSTR(TRIM(bas_saati),4,2))   * 60)) / 60. 
    psure = psure + (DATE(bit_tarihi) - DATE(bas_tarihi)) * 1440.       
    IF psure EQ ? THEN psure = 1.       
    IF psure < 0 THEN psure = 1.                                            
END. 


MESSAGE psure VIEW-AS ALERT-BOX.
