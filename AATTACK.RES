DECLARE SUB PAUSE ()
DECLARE SUB SCROFF (Par%)
DECLARE SUB PALLOAD (PALL$)
DECLARE SUB VGALOAD (VGAL$)
DECLARE SUB CGALOAD (CGAL$)
DECLARE SUB GREYPALS (Par%)
REM --------------------------------------------------------------------------
REM Alien Attack ver. 2.0
REM --------------------------------------------------------------------------
DECLARE SUB PRINTCFG (CFG() AS ANY)
DECLARE SUB PRINTSAF (SAF() AS ANY)
DECLARE SUB SETRGBCOL (COL%, R%, G%, B%)
DECLARE SUB SHOWINTRO (PATH$, VIDEO%, SNDBL%, MUSIC%)
REM --------------------------------------------------------------------------
DECLARE FUNCTION DEINT% (HEXDT0%, HEXDT1%)
REM --------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM $INCLUDE: 'AATTACK.BI'
REM --------------------------------------------------------------------------
DEFINT A-Z: ON ERROR GOTO ERHAND
REM --------------------------------------------------------------------------
DATAS:
REM --------------------------------------------------------------------------
DIM CFG(1) AS CFGheader, SAF(1) AS SAFheader
CONST SK = 1, STARTSPR = 1
REM --------------------------------------------------------------------------
PRINT
PRINT "Alien Attack ver. 2.0 Russian (Support VGA graphics)"
PRINT "Troy computing, Inc."
PRINT "Kolevatow Sergey (c) 1996": PRINT "Press any key to continue ...": PRINT : PAUSE
REM --------------------------------------------------------------------------
CONFIGURATION:
REM --------------------------------------------------------------------------
FF = FREEFILE
REM --------------------------------------------------------------------------
OPEN "B", FF, "AATTACK.CFG"
SEEK #FF, 0 + SK: GET #FF, , CFG(1).initCFG
SEEK #FF, 6 + SK: GET #FF, , CFG(1).PATH
SEEK #FF, 70 + SK: GET #FF, , CFG(1).USER
SEEK #FF, 326 + SK: GET #FF, , CFG(1).serNUM
SEEK #FF, 328 + SK: GET #FF, , CFG(1).videoCARD
SEEK #FF, 330 + SK: GET #FF, , CFG(1).sound
SEEK #FF, 332 + SK: GET #FF, , CFG(1).MUSIC
SEEK #FF, 334 + SK: GET #FF, , CFG(1).speed
CLOSE FF
REM --------------------------------------------------------------------------
FF = FREEFILE
REM --------------------------------------------------------------------------
OPEN "B", FF, "AATTACK.SAF"
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
PRINTCFG CFG(): PRINTSAF SAF(): PAUSE
SHOWINTRO CFG(1).PATH, CFG(1).videoCARD, CFG(1).sound, CFG(1).MUSIC
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
PRINT "PATH       : "; CFG(1).PATH
PRINT "USER       : "; LEFT$(CFG(1).USER, 50)
PRINT "serNUM     :"; CFG(1).serNUM
PRINT "videoCARD  :"; CFG(1).videoCARD
PRINT "sound      :"; CFG(1).sound
PRINT "music      :"; CFG(1).MUSIC
PRINT "speed      :"; CFG(1).speed
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

SUB SHOWINTRO (PATH$, VIDEO%, SNDBL%, MUSIC%)
REM --------------------------------------------------------------------------
PATH$ = RTRIM$(PATH$)
REM --------------------------------------------------------------------------
IF VIDEO% = 2 THEN SCREEN 1: GRP$ = "CGA"
IF VIDEO% = 4 THEN SCREEN 13: GRP$ = "VGA"
IF VIDEO% = 5 THEN SCREEN 13: GRP$ = "VGA"
REM --------------------------------------------------------------------------
IF SNDBL% = 0 THEN COMSTR$ = "ECHO >NUL"
IF SNDBL% = 1 THEN COMSTR$ = "WAVSPEAK.EXE"
IF SNDBL% = 3 THEN COMSTR$ = "WAVBLAST.EXE"
REM --------------------------------------------------------------------------
WHILE PRANYKEY$ = ""
REM --------------------------------------------------------------------------
PRANYKEY$ = INKEY$
IF SPRN < 10 THEN SPRN$ = "0" + LTRIM$(STR$(SPRN))
IF SPRN >= 10 THEN SPRN$ = LTRIM$(STR$(SPRN))
REM --------------------------------------------------------------------------
GFULNM$ = PATH$ + "\GRAPHS\" + GRP$ + "\" + "INTRO" + SPRN$
SFULNM$ = PATH$ + "\SOUND\" + "INTRO" + SPRN$
PFULNM$ = PATH$ + "\PROGS\"
REM --------------------------------------------------------------------------
IF VIDEO% = 2 THEN
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
	SHELL PFULNM$ + COMSTR$ + " " + SFULNM$ + ".WAV" + ">NUL"
END IF
REM --------------------------------------------------------------------------
PRANYKEY$ = INKEY$
SPRN = SPRN + 1:
IF SPRN = 13 THEN
	SPRN = 0
END IF
REM --------------------------------------------------------------------------
WEND
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

