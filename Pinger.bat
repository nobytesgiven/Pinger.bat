:: CC0 1.0 Universal LICENSED CODE: https://creativecommons.org/publicdomain/zero/1.0/legalcode

@MODE CON COLS=28 LINES=3
@echo off
@color 0F
echo Loading...
title Loading...
setlocal enabledelayedexpansion
	set ms=0
	set totalms=0
	set mscount=1
	set avgms=0
	set bytelength=1
	set pingtimes=1
	set pingip=8.8.8.8
cls
title Pinging...
echo Waiting For Response...

:main
for /F "tokens=3,7 delims==: " %%G in ('ping -l %bytelength% -n %pingtimes% %pingip% ^| findstr /C:"Reply from"') do (
	if not '%%H'=='' (
		set ms=%%H
		set ms=!ms:ms=!
	)
)

if %ms%== 0 (
	title OFFLINE 
	color 00 
	cls
	echo NO INTERNET CONNECTION
	goto :main 
	) else (
		set /a totalms=%totalms%+%ms%*%ms%
		set /a mscount=%mscount%+%ms%
		set /a avgms=%totalms%/%mscount%
		if %ms% leq 85 (
			color 0A
			) else (
				if %ms% leq 155 (
					color 0E
					) else (
						if %ms% geq 156 (color 0C) else (color 0F)
					)
			)
		cls
		
	)


title %ms%ms
echo Current: %ms%ms
if %avgms%== 0 (
	echo Average : %ms%ms 
) else (
	echo Average: %avgms%ms
)

goto :main
