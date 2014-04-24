
{C:\OpenEdge\BarsetProxy\windows.i}

DEFINE VARIABLE list-of-printers AS CHARACTER.
DEFINE VARIABLE newdefault AS CHARACTER INITIAL "TTTTT".
DEFINE VARIABLE driver-and-port AS CHARACTER INITIAL "OOOOOO".

DEFINE VARIABLE printername AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cchRet      AS INTEGER NO-UNDO.

RUN putkey 
  (INPUT "windows",
   INPUT "device",
   INPUT "C:\OpenEdge\BarsetProxy\win.ini",
   INPUT newdefault + "," + driver-and-port).


message session:printer-name view-as alert-box.

printername = FILL(" ",100).  /* = allocate memory, don't forget! */
RUN GetProfileString{&A} IN hpApi ("windows",
                                   "device",
                                   "-unknown-,",
                                   OUTPUT printername,
                                   LENGTH(printername),
                                   OUTPUT cchRet).

printername = ENTRY(1,printername).

IF printername="-unknown-" THEN
   MESSAGE "something is wrong with your WIN.INI" 
           VIEW-AS ALERT-BOX.
ELSE
   MESSAGE "your default printer is: " printername
           VIEW-AS ALERT-BOX.

PROCEDURE putkey :
DEFINE INPUT PARAMETER i-section AS CHARACTER.
DEFINE INPUT PARAMETER i-key AS CHARACTER.
DEFINE INPUT PARAMETER i-filename AS CHARACTER.
DEFINE INPUT PARAMETER i-value AS CHARACTER.
 
DEFINE VARIABLE cbReturnSize AS INTEGER.
 
RUN writeprivateprofilestring{&A} IN hpApi
                               (i-section, 
                                i-key, 
                                i-value,
                                i-filename, 
                                OUTPUT cbReturnSize ).
 
END PROCEDURE.
