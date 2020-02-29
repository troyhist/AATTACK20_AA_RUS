REM --------------------------------------------------------------------------
REM Alien Attack ver. 2.0
REM --------------------------------------------------------------------------
DECLARE FUNCTION DEINT% (HEXDT0%, HEXDT1%)
DECLARE FUNCTION SAFNE$ (FLNM$, Par%)
DECLARE FUNCTION NOTSTR$ (ASCSTR$)
DECLARE FUNCTION RETHARD$ (DATAS%, NUM%)
REM --------------------------------------------------------------------------
DECLARE SUB PAUSE ()
DECLARE SUB PRINTCFG (CFG() AS ANY)
DECLARE SUB PRINTSAF (SAF() AS ANY)
DECLARE SUB SETRGBCOL (COL%, R%, G%, B%)
DECLARE SUB SCROFF (Par%)
DECLARE SUB SHOWINTRO (CFG() AS ANY, SAF() AS ANY)
DECLARE SUB PALLOAD (PALL$)
DECLARE SUB VGALOAD (VGAL$)
DECLARE SUB CGALOAD (CGAL$)
DECLARE SUB GREYPALS (Par%)
REM --------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM $INCLUDE: 'AATTACK.BI'
REM --------------------------------------------------------------------------
DEFINT A-Z: 'ON ERROR GOTO ERHAND
REM --------------------------------------------------------------------------
DATAS:
REM --------------------------------------------------------------------------
DIM CFG(1) AS CFGheader, SAF(1) AS SAFheader
CONST STARTSPR = 1
REM --------------------------------------------------------------------------
PRINT
PRINT "Alien Attack ver. 2.0 (Support VGA graphics)"
PRINT "Troy computing, Inc."
PRINT "Kolevatow Sergey (c) 1996": PRINT "Press any key to continue ...": PRINT : PAUSE
REM --------------------------------------------------------------------------
CONFIGURATION:
REM --------------------------------------------------------------------------
FF = FREEFILE
REM --------------------------------------------------------------------------
OPEN "B", FF, CFGFL$
SEEK #FF, 0 + SK: GET #FF, , CFG(1).initCFG
SEEK #FF, 6 + SK: GET #FF, , CFG(1).PATH
SEEK #FF, 70 + SK: GET #FF, , CFG(1).USER
SEEK #FF, 326 + SK: GET #FF, , CFG(1).serNUM
SEEK #FF, 328 + SK: GET #FF, , CFG(1).videoCARD
SEEK #FF, 330 + SK: GET #FF, , CFG(1).sound
SEEK #FF, 332 + SK: GET #FF, , CFG(1).music
SEEK #FF, 334 + SK: GET #FF, , CFG(1).speed
CLOSE FF
REM --------------------------------------------------------------------------
FF = FREEFILE
REM --------------------------------------------------------------------------
OPEN "B", FF, SAFFL$
SEEK #FF, 0 + SK: GET #FF, , SAF(1).initSAF
SEEK #FF, 6 + SK: GET #FF, , SAF(1).introPICS
SEEK #FF, 15 + SK: GET #FF, , SAF(1).introWAVS
SEEK #FF, 24 + SK: GET #FF, , SAF(1).levelPICS
SEEK #FF, 33 + SK: GET #FF, , SAF(1).levelWAVS
SEEK #FF, 42 + SK: GET #FF, , SAF(1).gameSPRS
SEEK #FF, 50 + SK: GET #FF, , SAF(1).gameBGRS
SEEK #FF, 58 + SK: GET #FF, , SAF(1).Levels
SEEK #FF, 60 + SK: GET #FF, , SAF(1).Sprites
SEEK #FF, 62 + SK: GET #FF, , SAF(1).Backs
CLOSE FF
REM --------------------------------------------------------------------------
PRINTCFG CFG(): PRINTSAF SAF(): CALL PAUSE
SHOWINTRO CFG(), SAF()
END
REM --------------------------------------------------------------------------
ERHAND:
REM --------------------------------------------------------------------------
BEEP: PRINT "ERROR: Number"; ERR; "in line"; ERL
END
REM --------------------------------------------------------------------------

SUB CGALOAD (CGAL$)
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(CGAL$) + ".CGA"
REM --------------------------------------------------------------------------
REM IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
DEF SEG = &HB800: BLOAD FLNM$, 0: DEF SEG
REM --------------------------------------------------------------------------
END SUB

FUNCTION DEINT% (HEXDT0%, HEXDT1%)
HEXDT0$ = HEX$(HEXDT0%)
HEXDT1$ = HEX$(HEXDT1%)
IF HEXDT0% < 16 THEN HEXDT0$ = "0" + HEXDT0$
IF HEXDT1% < 16 THEN HEXDT1$ = "0" + HEXDT1$
HEXDAT$ = HEXDT0$ + HEXDT1$
DEINT% = VAL("&H" + HEXDAT$)
END FUNCTION

SUB GREYPALS (Par%)
DIM regs AS RegType
IF Par% < 0 OR Par% > 1 THEN Par% = 0
regs.ax = &H101B
regs.bx = &H0
IF Par% = 0 THEN regs.cx = &H1
IF Par% = 1 THEN regs.cx = &H256
interrupt &H10, regs, regs
END SUB

FUNCTION NOTSTR$ (ASCSTR$)
FOR A = 1 TO LEN(ASCSTR$)
B$ = MID$(ASCSTR$, A, 1)
C = 255 - ASC(B$)
C$ = CHR$(C)
NEWSTR$ = NEWSTR$ + C$
NEXT A
NOTSTR$ = NEWSTR$
END FUNCTION

SUB PALLOAD (PALL$)
REM --------------------------------------------------------------------------
SHARED PALheader.initPAL AS STRING * 6
SHARED PALheader.NAME    AS STRING * 11
SHARED PALheader.Caption AS STRING * 256
SHARED PALheader.usCOL   AS INTEGER
SHARED PALheader.fstCOL  AS INTEGER
SHARED PALheader.palTYPE AS INTEGER
SHARED PALheader.DATAS   AS STRING * 768
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(PALL$) + ".PAL":  FF = FREEFILE: STRPOS = 1
REM --------------------------------------------------------------------------
REM IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
SEEK #1, SK + 273: GET #1, , PALheader.usCOL
SEEK #1, SK + 275: GET #1, , PALheader.fstCOL
SEEK #1, SK + 279: GET #1, , PALheader.DATAS
CLOSE FF
REM --------------------------------------------------------------------------
FOR TMPCOL% = PALheader.fstCOL TO PALheader.usCOL - 1
R% = ASC(MID$(PALheader.DATAS, STRPOS + 0, 1))
G% = ASC(MID$(PALheader.DATAS, STRPOS + 1, 1))
B% = ASC(MID$(PALheader.DATAS, STRPOS + 2, 1))
STRPOS = STRPOS + 3
SETRGBCOL TMPCOL%, R%, G%, B%
NEXT TMPCOL%
REM --------------------------------------------------------------------------
END SUB

SUB PAUSE
WHILE A$ = ""
A$ = INKEY$
WEND
END SUB

SUB PRINTCFG (CFG() AS CFGheader)
REM --------------------------------------------------------------------------
CHKCFG:
REM --------------------------------------------------------------------------
PRINT "Checking AATTACK.CFG data ...": PRINT
PRINT "initCFG    : "; CFG(1).initCFG
PRINT "PATH       : "; NOTSTR$(CFG(1).PATH)
PRINT "USER       : "; NOTSTR$(LEFT$(CFG(1).USER, 50))
PRINT "serNUM     :"; CFG(1).serNUM
PRINT "videoCARD  : "; RETHARD$(CFG(1).videoCARD, 4)
PRINT "sound      : "; RETHARD$(CFG(1).sound, 5)
PRINT "music      : "; RETHARD$(CFG(1).music, 6)
PRINT "speed      : "; RETHARD$(CFG(1).speed, 7)
PRINT
REM --------------------------------------------------------------------------
END SUB

SUB PRINTSAF (SAF() AS SAFheader)
REM --------------------------------------------------------------------------
CHKSAF:
REM --------------------------------------------------------------------------
PRINT "Checking AATTACK.SAF data ...": PRINT
PRINT "initSAF    : "; SAF(1).initSAF
PRINT "introPICS  : "; SAF(1).introPICS
PRINT "introWAVS  : "; SAF(1).introWAVS
PRINT "levelPICS  : "; SAF(1).levelPICS
PRINT "levelWAVS  : "; SAF(1).levelWAVS
PRINT "gameSPRS   : "; SAF(1).gameSPRS
PRINT "gameBGRS   : "; SAF(1).gameBGRS
PRINT "Levels     :"; SAF(1).Levels
PRINT "Sprites    :"; SAF(1).Sprites
PRINT "Backs      :"; SAF(1).Backs
REM --------------------------------------------------------------------------
END SUB

FUNCTION RETHARD$ (DATAS%, NUM%)
REM --------------------------------------------------------------------------
IF NUM% < 4 OR NUM% > 7 THEN NUM% = 4
IF DATAS% < 0 THEN DATAS% = 0
REM --------------------------------------------------------------------------
IF NUM% = 4 THEN
	IF DATAS% = 0 THEN TMPHARD$ = "CGA-mono"
	IF DATAS% = 1 THEN TMPHARD$ = "CGA-mono"
	IF DATAS% = 2 THEN TMPHARD$ = "CGA-colour"
	IF DATAS% = 3 THEN TMPHARD$ = "EGA-standart"
	IF DATAS% = 4 THEN TMPHARD$ = "VGA-mono"
	IF DATAS% = 5 THEN TMPHARD$ = "VGA-standart"
	IF DATAS% > 5 THEN TMPHARD$ = "Reserved"
REM --------------------------------------------------------------------------
ELSEIF NUM% = 5 OR NUM% = 6 THEN
	IF DATAS% = 0 AND NUM% = 5 THEN TMPHARD$ = "No sound"
	IF DATAS% = 0 AND NUM% = 6 THEN TMPHARD$ = "No music"
	IF DATAS% = 1 THEN TMPHARD$ = "PC-speaker"
	IF DATAS% = 2 THEN TMPHARD$ = "AdLib"
	IF DATAS% = 3 THEN TMPHARD$ = "Sound Blaster 8 Bit"
	IF DATAS% = 4 THEN TMPHARD$ = "Sound Blaster Pro 8 Bit"
	IF DATAS% > 4 THEN TMPHARD$ = "Reserved"
REM --------------------------------------------------------------------------
ELSEIF NUM% = 7 THEN
	IF DATAS% = 0 THEN TMPHARD$ = "PC XT"
	IF DATAS% = 1 THEN TMPHARD$ = "PC XT Turbo"
	IF DATAS% = 2 THEN TMPHARD$ = "PC AT 286"
	IF DATAS% = 3 THEN TMPHARD$ = "AT 386 SX"
	IF DATAS% = 4 THEN TMPHARD$ = "AT 386 DX"
	IF DATAS% = 5 THEN TMPHARD$ = "AT 486 SX"
	IF DATAS% = 6 THEN TMPHARD$ = "AT 486 DX"
	IF DATAS% = 7 THEN TMPHARD$ = "AT 486 DX2"
	IF DATAS% = 8 THEN TMPHARD$ = "AT 486 DX4"
	IF DATAS% = 9 THEN TMPHARD$ = "Pentium - 120"
	IF DATAS% = 10 THEN TMPHARD$ = "Pentium - 133"
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
RETHARD$ = TMPHARD$
END FUNCTION

FUNCTION SAFNE$ (FLNM$, Par%)
REM --------------------------------------------------------------------------
IF Par% < 0 OR Par% > 1 THEN Par% = 0
REM --------------------------------------------------------------------------
IF FLNM$ = "" THEN ERROR 52
REM --------------------------------------------------------------------------
FOR TMPA = 1 TO LEN(FLNM$)
TMPB$ = MID$(FLNM$, TMPA, 1)
IF TMPB$ = CHR$(32) THEN
	NAME$ = MID$(FLNM$, 1, TMPA - 1)
	EXTN$ = LTRIM$(MID$(FLNM$, TMPA + 1))
END IF
NEXT TMPA
REM --------------------------------------------------------------------------
IF NAME$ = "" THEN ERROR 52
REM --------------------------------------------------------------------------
IF Par% = 0 THEN SAFNE$ = NAME$
IF Par% = 1 THEN SAFNE$ = EXTN$
END FUNCTION

SUB SCROFF (Par%)
IF Par% < 0 OR Par% > 1 THEN Par% = 0
DIM regs AS RegType
IF Par% = 0 THEN regs.ax = &H1200 + &H0
IF Par% = 1 THEN regs.ax = &H1200 + &H1
regs.bx = &H36
interrupt &H10, regs, regs
END SUB

SUB SETRGBCOL (COL%, R%, G%, B%)
DIM regs AS RegType
regs.ax = &H1010
regs.bx = COL%
regs.cx = DEINT%(G%, B%)
regs.dx = DEINT%(R%, 0)
interrupt &H10, regs, regs
END SUB

SUB SHOWINTRO (CFG() AS CFGheader, SAF() AS SAFheader)
REM --------------------------------------------------------------------------
PATH$ = RTRIM$(NOTSTR$(CFG(1).PATH))
VIDEO% = CFG(1).videoCARD
SNDBL% = CFG(1).sound
REM --------------------------------------------------------------------------
IF VIDEO% = 0 THEN SCREEN 1: GRP$ = "CGA"
IF VIDEO% = 1 THEN SCREEN 2: GRP$ = "CGA"
IF VIDEO% = 2 THEN SCREEN 1: GRP$ = "CGA"
IF VIDEO% = 4 THEN SCREEN 13: GRP$ = "VGA"
IF VIDEO% = 5 THEN SCREEN 13: GRP$ = "VGA"
REM --------------------------------------------------------------------------
INTROGFILE$ = SAFNE$(SAF(1).introPICS, 0)
INTROSFILE$ = SAFNE$(SAF(1).introWAVS, 0)
SOUNDEXTEN$ = SAFNE$(SAF(1).introWAVS, 1)
REM --------------------------------------------------------------------------
IF SNDBL% = 0 THEN COMSTR$ = "ECHO >NUL"
IF SNDBL% = 1 THEN COMSTR$ = "WAVSPEAK.EXE"
IF SNDBL% = 3 THEN COMSTR$ = "WAVBLAST.EXE"
REM --------------------------------------------------------------------------
DO UNTIL PRANYKEY$ = CHR$(27)
REM --------------------------------------------------------------------------
PRANYKEY$ = INKEY$
IF SPRN < 10 THEN SPRN$ = "0" + LTRIM$(STR$(SPRN))
IF SPRN >= 10 THEN SPRN$ = LTRIM$(STR$(SPRN))
REM --------------------------------------------------------------------------
GFULNM$ = PATH$ + "\GRAPHS\" + GRP$ + "\" + INTROGFILE$ + SPRN$
SFULNM$ = PATH$ + "\SOUND\" + INTROSFILE$ + SPRN$
PFULNM$ = PATH$ + "\PROGS\"
REM --------------------------------------------------------------------------
IF VIDEO% = 1 OR VIDEO% = 2 THEN
	SLEEP 3
	CGALOAD GFULNM$
ELSEIF VIDEO% = 4 THEN
	SCROFF 1:
	PALLOAD GFULNM$:
	GREYPALS 1
	VGALOAD GFULNM$:
	SCROFF 0:
ELSEIF VIDEO% = 5 THEN
	SCROFF 1:
	PALLOAD GFULNM$:
	VGALOAD GFULNM$:
	SCROFF 0:
END IF
REM --------------------------------------------------------------------------
IF SNDBL% = 0 THEN
	SLEEP 5
ELSE
	SHELL PFULNM$ + COMSTR$ + " " + SFULNM$ + "." + SOUNDEXTEN$ + ">NUL"
END IF
REM --------------------------------------------------------------------------
SPRN = SPRN + 1:
IF SPRN = 13 THEN
	SPRN = 0
END IF
REM --------------------------------------------------------------------------
LOOP
END SUB

SUB VGALOAD (VGAL$)
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(VGAL$) + ".VGA"
REM --------------------------------------------------------------------------
REM IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
DEF SEG = &HA000: BLOAD FLNM$, 0: DEF SEG
REM --------------------------------------------------------------------------
END SUB

