@echo off
xcopy img bin\win\img\ /E
ocra --windows --output bin/win/MonsterMaze.exe main.rb
