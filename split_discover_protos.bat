mode con: cols=200 lines=60
Powershell.exe -File split_discover_protos.ps1 -SourceFolder "%cd%\src\POGOProtos" -OutFile "%cd%\proto_index.txt" 
pause