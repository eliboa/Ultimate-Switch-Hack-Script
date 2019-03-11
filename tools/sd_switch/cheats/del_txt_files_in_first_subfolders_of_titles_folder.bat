@echo off
for /D %%i in (*) do (
cd %%i
del /q *.txt
cd ..
)
pause