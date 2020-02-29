REM --------------------------------------------------------------------------
REM Alien Attack Setup ver. 1.0
REM --------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM $INCLUDE: 'AATTACK.BI'
REM --------------------------------------------------------------------------
DECLARE FUNCTION RETHARD$ (DATAS%, NUM%)
DECLARE FUNCTION CHITEM% (FROM%, ABSL%, LOCX%, LOCY%)
DECLARE FUNCTION NOTSTR$ (ASCSTR$)
REM --------------------------------------------------------------------------
DECLARE SUB CLEARSCR (Par%)
DECLARE SUB CREATSCR (CFG() AS ANY, Par%)
DECLARE SUB SAVECFG (CFG() AS ANY)
DECLARE SUB SCRLOAD ()
DECLARE SUB SHOWSCR (ASCCOD%, COL%)
DECLARE SUB SCRSAVE ()
DECLARE SUB PAUSE ()
REM --------------------------------------------------------------------------
DEFINT A-Z: ON ERROR GOTO ERHAND
REM --------------------------------------------------------------------------
DATAS:
REM --------------------------------------------------------------------------
DIM CFG(1) AS CFGheader:
REM --------------------------------------------------------------------------
IF DIR$(CFGFL$) <> CFGFL$ THEN
	CFG(1).initCFG = "CFG96a"
	CFG(1).PATH = NOTSTR$(CURDIR$) + STRING$(64, 223)
	CFG(1).USER = NOTSTR$(TCTM$) + STRING$(256, 223)
	CFG(1).serNUM = &HFFFF
	CFG(1).videoCARD = 5
	CFG(1).sound = 3
	CFG(1).music = 0
	CFG(1).speed = 5
REM --------------------------------------------------------------------------
ELSE
FF = FREEFILE: OPEN "B", FF, CFGFL$
SEEK #FF, 0 + SK: GET #1, , CFG(1).initCFG
SEEK #FF, 6 + SK: GET #1, , CFG(1).PATH
SEEK #FF, 70 + SK: GET #1, , CFG(1).USER
SEEK #FF, 326 + SK: GET #1, , CFG(1).serNUM
SEEK #FF, 328 + SK: GET #1, , CFG(1).videoCARD
SEEK #FF, 330 + SK: GET #1, , CFG(1).sound
SEEK #FF, 332 + SK: GET #1, , CFG(1).music
SEEK #FF, 334 + SK: GET #1, , CFG(1).speed
CLOSE FF
END IF
REM --------------------------------------------------------------------------
RESTART:
REM --------------------------------------------------------------------------
CREATSCR CFG(), 0: LOCATE 19, 6: PRINT "Выбери одну из опций - "; : ITEM% = CHITEM%(1, 4, 29, 19)
REM --------------------------------------------------------------------------
IF ITEM% = 0 THEN ITEM% = 4
IF ITEM% = 1 THEN
	WHILE ITEM% <> 0
	CREATSCR CFG(), 1
	ITEM% = CHITEM%(1, 6, 29, 12)
	IF ITEM% = 6 THEN SCRLOAD: GOTO RESTART
	IF ITEM% = 1 THEN
		CREATSCR CFG(), 2
		INPUT "", P$: P$ = LTRIM$(UCASE$(P$))
		IF P$ <> "" THEN
			IF LEN(P$) > 64 THEN P$ = LEFT$(P$, 64)
			IF RIGHT$(P$, 1) = "\" THEN P$ = LEFT$(P$, LEN(P$) - 1)
			CFG(1).PATH = NOTSTR$(P$ + STRING$(64, CHR$(32)))
		END IF
	END IF
	IF ITEM% = 2 THEN CREATSCR CFG(), 3: CFG(1).videoCARD = CHITEM%(1, 5, 29, 11)
	IF ITEM% = 3 THEN CREATSCR CFG(), 4: CFG(1).sound = CHITEM%(1, 5, 29, 11) - 1
	IF ITEM% = 4 THEN CREATSCR CFG(), 5: CFG(1).music = CHITEM%(1, 5, 29, 11) - 1
	IF ITEM% = 5 THEN CREATSCR CFG(), 6: CFG(1).speed = CHITEM%(1, 9, 29, 15)
	WEND: SCRLOAD
	GOTO RESTART
ELSEIF ITEM% = 2 OR ITEM% = 3 THEN
	SAVECFG CFG()
	IF ITEM% = 2 THEN
		LOCATE 21, 6: PRINT "Конфигурация записана ... Нажми любую кнопку"
		CALL PAUSE: SCRLOAD
		RUN
	ELSEIF ITEM% = 3 THEN
		LOCATE 21, 6: PRINT "Конфигурация записана ... Нажми любую кнопку для выхода"
		PAUSE
	END IF
REM --------------------------------------------------------------------------
ELSEIF ITEM% = 4 THEN
	LOCATE 21, 6: PRINT "Конфигурация не записана ... Нажми любую кнопку"
	PAUSE
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
CALL SCRLOAD: COLOR 7, 0, 0: END
REM --------------------------------------------------------------------------
ERHAND:
REM --------------------------------------------------------------------------
CALL SCRLOAD: COLOR 7, 0, 0: PRINT "ERROR: Number"; ERR; "in line"; ERL: END
REM --------------------------------------------------------------------------

FUNCTION CHITEM% (FROM%, ABSL%, LOCX%, LOCY%)
LOCATE LOCY%, LOCX%: COLOR 24: PRINT "_"
WHILE I% < FROM% OR I% > ABSL%
I$ = INKEY$
I% = VAL(I$)
IF MID$(I$, 2, 1) = CHR$(45) THEN
	SCRLOAD
	COLOR 7, 0, 0
	END
END IF
IF I$ = CHR$(27) THEN
	LOCATE LOCY%, LOCX%:
	COLOR 15, 7: PRINT "0":
	EXIT FUNCTION
END IF
WEND
LOCATE LOCY%, LOCX%: COLOR 15, 7: PRINT LTRIM$(STR$(I%))
CHITEM% = I%
END FUNCTION

SUB CLEARSCR (Par%)
REM --------------------------------------------------------------------------
IF Par% < 0 OR Par% > 1 THEN Par% = 0
REM --------------------------------------------------------------------------
IF Par% = 0 THEN
REM --------------------------------------------------------------------------
CALL SCRSAVE: SHOWSCR &HB0, &H71: COLOR 7, 8
LOCATE 1, 1: PRINT STRING$(80, 219)
LOCATE 25, 1: PRINT STRING$(80, 219); : COLOR 8, 2
LOCATE 1, 25: PRINT " Атака Чужих Накстройка вер. 1.0 ": COLOR 4, 7
LOCATE 1, 3: PRINT "Ф": LOCATE 1, 9: PRINT "О"
LOCATE 25, 2: PRINT "Alt-Ч "; : COLOR 0, 7
LOCATE 1, 4: PRINT "аил": LOCATE 1, 10: PRINT "пции"
LOCATE 25, 8: PRINT "Выход"; : COLOR 15, 7
REM --------------------------------------------------------------------------
ELSEIF Par% = 1 THEN
REM --------------------------------------------------------------------------
SHOWSCR &HB0, &H71: COLOR 7, 8
LOCATE 1, 1: PRINT STRING$(80, 219)
LOCATE 25, 1: PRINT STRING$(80, 219); : COLOR 8, 2
LOCATE 1, 25: PRINT " Атака Чужих Накстройка вер. 1.0 ": COLOR 4, 7
LOCATE 25, 2: PRINT "Alt-Ч "; : COLOR 0, 7
LOCATE 25, 8: PRINT "Выход"; : COLOR 15, 7
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
END SUB

SUB CREATSCR (CFG() AS CFGheader, Par%)
REM --------------------------------------------------------------------------
IF Par% < 0 OR Par% > 6 THEN Par% = 0
REM --------------------------------------------------------------------------
IF Par% = 0 THEN
REM --------------------------------------------------------------------------
CLEARSCR 0
LOCATE 3, 3: PRINT "Информация настройки:"
REM --------------------------------------------------------------------------
LOCATE 5, 3: PRINT "initCFG         : "; CFG(1).initCFG
LOCATE 6, 3: PRINT "Путь            : "; RTRIM$(NOTSTR$(CFG(1).PATH))
LOCATE 7, 3: PRINT "Имя пользователя: "; RTRIM$(LEFT$(NOTSTR$(CFG(1).USER), 64))
LOCATE 8, 3: PRINT "Серийный номер  :"; CFG(1).serNUM
LOCATE 9, 3: PRINT "Видео карта     : "; RETHARD$(CFG(1).videoCARD, 4)
LOCATE 10, 3: PRINT "Звук            : "; RETHARD$(CFG(1).sound, 5)
LOCATE 11, 3: PRINT "Музыка          : "; RETHARD$(CFG(1).music, 6)
LOCATE 12, 3: PRINT "Тип компьютера  : "; RETHARD$(CFG(1).speed, 7)
REM --------------------------------------------------------------------------
LOCATE 14, 3: PRINT "1. Редактировать текущую конфигурацию"
LOCATE 15, 3: PRINT "2. Записать текущую конфигурацию"
LOCATE 16, 3: PRINT "3. Записать и Выйти"
LOCATE 17, 3: PRINT "4. Выйти без записи"
REM --------------------------------------------------------------------------
ELSEIF Par% = 1 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Параметры для редактирования:"
LOCATE 5, 3: PRINT "1. Путь          : "; RTRIM$(NOTSTR$(CFG(1).PATH))
LOCATE 6, 3: PRINT "2. Видео карта   : "; RETHARD$(CFG(1).videoCARD, 4)
LOCATE 7, 3: PRINT "3. Звук          : "; RETHARD$(CFG(1).sound, 5)
LOCATE 8, 3: PRINT "4. Музыка        : "; RETHARD$(CFG(1).music, 6)
LOCATE 9, 3: PRINT "5. Тип компьютера: "; RETHARD$(CFG(1).speed, 7)
LOCATE 10, 3: PRINT "6. Выход"
LOCATE 12, 6: PRINT "Выбери одну из опций - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 2 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Старый путь        : "; RTRIM$(NOTSTR$(CFG(1).PATH))
LOCATE 5, 3: PRINT "Введите новый путь : ";
REM --------------------------------------------------------------------------
ELSEIF Par% = 3 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Видео карта:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(1, 4)
LOCATE 6, 3: PRINT "2. "; RETHARD$(2, 4)
LOCATE 7, 3: PRINT "3. "; RETHARD$(3, 4)
LOCATE 8, 3: PRINT "4. "; RETHARD$(4, 4)
LOCATE 9, 3: PRINT "5. "; RETHARD$(5, 4)
LOCATE 11, 6: PRINT "Выбери одну из опций - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 4 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Звуковая карта:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(0, 5)
LOCATE 6, 3: PRINT "2. "; RETHARD$(1, 5)
LOCATE 7, 3: PRINT "3. "; RETHARD$(2, 5)
LOCATE 8, 3: PRINT "4. "; RETHARD$(3, 5)
LOCATE 9, 3: PRINT "5. "; RETHARD$(4, 5)
LOCATE 11, 6: PRINT "Выбери одну из опций - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 5 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Музыкальная карта:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(0, 6)
LOCATE 6, 3: PRINT "2. "; RETHARD$(1, 6)
LOCATE 7, 3: PRINT "3. "; RETHARD$(2, 6)
LOCATE 8, 3: PRINT "4. "; RETHARD$(3, 6)
LOCATE 9, 3: PRINT "5. "; RETHARD$(4, 6)
LOCATE 11, 6: PRINT "Выбери одну из опций - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 6 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Тип компьютера:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(1, 7)
LOCATE 6, 3: PRINT "2. "; RETHARD$(2, 7)
LOCATE 7, 3: PRINT "3. "; RETHARD$(3, 7)
LOCATE 8, 3: PRINT "4. "; RETHARD$(4, 7)
LOCATE 9, 3: PRINT "5. "; RETHARD$(5, 7)
LOCATE 10, 3: PRINT "6. "; RETHARD$(6, 7)
LOCATE 11, 3: PRINT "7. "; RETHARD$(7, 7)
LOCATE 12, 3: PRINT "8. "; RETHARD$(8, 7)
LOCATE 13, 3: PRINT "9. "; RETHARD$(9, 7)
LOCATE 15, 6: PRINT "Выбери одну из опций - "
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
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

SUB PAUSE
WHILE A$ = ""
A$ = INKEY$
WEND
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
	IF DATAS% > 5 THEN TMPHARD$ = "Зарезервированно"
REM --------------------------------------------------------------------------
ELSEIF NUM% = 5 OR NUM% = 6 THEN
	IF DATAS% = 0 AND NUM% = 5 THEN TMPHARD$ = "Без звуков"
	IF DATAS% = 0 AND NUM% = 6 THEN TMPHARD$ = "Без музыки"
	IF DATAS% = 1 THEN TMPHARD$ = "PC-speaker"
	IF DATAS% = 2 THEN TMPHARD$ = "AdLib"
	IF DATAS% = 3 THEN TMPHARD$ = "Sound Blaster 8 Bit"
	IF DATAS% = 4 THEN TMPHARD$ = "Sound Blaster Pro 8 Bit"
	IF DATAS% > 4 THEN TMPHARD$ = "Зарезервированно"
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
	IF DATAS% = &HA THEN TMPHARD$ = "Pentium - 133"
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
RETHARD$ = TMPHARD$
END FUNCTION

SUB SAVECFG (CFG() AS CFGheader)
REM --------------------------------------------------------------------------
	FF = FREEFILE: OPEN "B", FF, CFGFL$
	SEEK #FF, 0 + SK: PUT #1, , CFG(1).initCFG
	SEEK #FF, 6 + SK: PUT #1, , CFG(1).PATH
	SEEK #FF, 70 + SK: PUT #1, , CFG(1).USER
	SEEK #FF, 326 + SK: PUT #1, , CFG(1).serNUM
	SEEK #FF, 328 + SK: PUT #1, , CFG(1).videoCARD
	SEEK #FF, 330 + SK: PUT #1, , CFG(1).sound
	SEEK #FF, 332 + SK: PUT #1, , CFG(1).music
	SEEK #FF, 334 + SK: PUT #1, , CFG(1).speed
	CLOSE FF
REM --------------------------------------------------------------------------
END SUB

SUB SCRLOAD
DEF SEG = &HB800: BLOAD "$$%SCR%$.CLT", 0: DEF SEG : KILL "$$%SCR%$.CLT"
END SUB

SUB SCRSAVE
DEF SEG = &HB800: BSAVE "$$%SCR%$.CLT", 0, 4000: DEF SEG
END SUB

SUB SHOWSCR (ASCCOD%, COL%)
DEF SEG = &HB800
FOR A = 0 TO 4000 STEP 2
POKE A + 0, ASCCOD%
POKE A + 1, COL%
NEXT A
DEF SEG
END SUB

