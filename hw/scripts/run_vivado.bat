@echo off
echo Running Vivado in batch mode...

set VIVADO=C:\Xilinx\Vivado\2024.1\bin\vivado.bat
set PROJ_DIR=D:\Github\final_thesis\hw
set TCL=%PROJ_DIR%\scripts\top_sys_vivado.tcl

::"%VIVADO%" -mode batch -source "%TCL%" -log "%PROJ_DIR%\vivado.log"
"%VIVADO%" -mode gui -source "%TCL%"

pause
