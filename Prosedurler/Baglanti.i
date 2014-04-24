
DEFINE VARIABLE barset-log-dir AS CHARACTER INITIAL "C:\OpenEdge\BarsetProxy\log\".
DEFINE VARIABLE barset-test-app AS LOGICAL INITIAL TRUE.

CONNECT -pf "C:\OpenEdge\finans2011.pf" NO-ERROR.

IF barset-test-app THEN DO:
    DISPLAY "Islem:, Zamani:" TODAY.
    /*DISPLAY "Islem:" SOURCE-PROCEDURE:NAME ", Zamani:" TODAY.*/
END.
