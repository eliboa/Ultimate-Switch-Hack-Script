@echo off
cd titles
for /D %%i in (*) do (
cd %%i
del /q *.txt
cd ..
)
cd ..
pause