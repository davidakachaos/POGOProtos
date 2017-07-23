mode con: cols=200 lines=60
@rem Powershell.exe -File split_proto.ps1 -Sourcefile "%cd%\base\v0.69.0.proto" -OutPath "%cd%\temp_out" -ProtoIndexFile "%cd%\proto_index.txt" -SrcFolder "%cd%\src" > output.txt
Powershell.exe -File split_proto.ps1 -Sourcefile "%cd%\base\v0.69.0.proto" -OutPath "%cd%\temp_out" -ProtoIndexFile "%cd%\proto_index.txt" -SrcFolder "%cd%\src"
pause