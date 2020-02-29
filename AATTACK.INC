REM --------------------------------------------------------------------------
REM Alien ATTACK include file ver. 2.0
REM --------------------------------------------------------------------------
TYPE CFGheader
	initCFG   AS STRING * 6
	PATH      AS STRING * 64
	USER      AS STRING * 256
	serNUM    AS INTEGER
	videoCARD AS INTEGER
	sound     AS INTEGER
	MUSIC     AS INTEGER
	speed     AS INTEGER
END TYPE
REM --------------------------------------------------------------------------
TYPE SAFheader
	initSAF   AS STRING * 6
	introPICS AS STRING * 9
	introWAVS AS STRING * 9
	levelPICS AS STRING * 9
	levelWAVS AS STRING * 9
	gameSPRS  AS STRING * 8
	gameBGRS  AS STRING * 8
	Levels    AS INTEGER
	Sprites   AS INTEGER
	Backs     AS INTEGER
END TYPE
REM --------------------------------------------------------------------------
