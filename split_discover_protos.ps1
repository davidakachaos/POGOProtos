Param (

  [Parameter(Mandatory=$true)]
    [String] $SourceFolder,
  [Parameter(Mandatory=$true)]
    [String] $OutFile
)


function GetFiles($path = $pwd, [string[]]$exclude)
{
    foreach ($item in Get-ChildItem $path)
    {
        if ($exclude | Where {$item -like $_}) { continue }

        $item
        if (Test-Path $item.FullName -PathType Container)
        {
            GetFiles $item.FullName $exclude
        }
    }
} 


$EnumPattern = [RegEx] '^enum '
$MessagePattern = [RegEx] '^message '

#MAIN PROGRAMM
$SourceFiles = GetFiles($SourceFolder)

#Create output file
New-Item $OutFile -type file -force

ForEach ($File in $SourceFiles) {
    #echo "Opening:" $File.FullName
    
    If ( ([IO.FileInfo]"$($File.FullName)").Attributes -match 'Directory') {
        #This is a folder, so skip this loop
        Continue
    }
    
    $ProtoData = Get-Content -Path "$($File.FullName)"
    ForEach ($ProtoLine in $ProtoData) {
      If ($ProtoLine -match $EnumPattern -or $ProtoLine -match $MessagePattern) {  
        #enum or message line found

        #Remove the { at the end
        if ($ProtoLine.contains("{") ) {
            $ProtoLine=$ProtoLine.Substring(0,$ProtoLine.Length-2)
        }
        else {}
        
        Add-Content -Path "$OutFile" -Value $ProtoLine
        echo $ProtoLine
        Add-Content -Path "$OutFile" -Value $File.FullName
        echo $File.FullName
      }
      Else {}
      
    }  #End ForEach


<#  
If ($Line -match $FNPattern) {  
    $FN = $Line.Trim() | ForEach-Object {$_.Substring(3,($_.Length-6))}  
    $CurrentFN = $OutPath + "$($FN.trim())" + ".txt" 
  }
  Else {
    If ($StripBlankLines.IsPresent -and ($Line.Trim().Length -eq 0)) {
    }
    Else {
      Add-Content -Path "$CurrentFN" -Value $Line
    }
  } 
#>

}  #End ForEach



