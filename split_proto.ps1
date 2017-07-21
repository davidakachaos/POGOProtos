Param (

  [Parameter(Mandatory=$true)]
    [String] $Sourcefile,
  [Parameter(Mandatory=$true)]
    [String] $SrcFolder,
  [Parameter(Mandatory=$true)]
    [String] $ProtoIndexFile,
  [Parameter(Mandatory=$true)]
    [String] $OutPath,
  [Parameter(Mandatory=$false)]
    [Switch] $StripBlankLines
)

$EnumPattern = [RegEx] '^enum '
$MessagePattern = [RegEx] '^message '

$lookupTable = @{
'enum Item' = 'enum ItemId' 
'enum HoloActivityType' = 'enum BadgeType' 
'enum TutorialCompletion' = 'enum TutorialState' 
'message AwardItemProto' = 'message ItemAward' 
'message FortDeployProto' = 'message FortDeployPokemonMessage' 
'message FortDeployOutProto' = 'message FortDeployPokemonResponse' 
'message UseIncenseActionProto' = 'message UseIncenseMessage' 
'message UseIncenseActionOutProto' = 'message UseIncenseResponse' 
'message PokemonInfo' = 'message BattlePokemonInfo' 
'message CodenameResultProto' = 'message CheckCodenameAvailableResponse' 

'enum PokemonCreateContext' = 'NOT FOUND'
'enum Team' = 'NOT FOUND'
'enum HoloPokemonClass' = 'NOT FOUND'
'enum HoloPokemonNature' = 'NOT FOUND'
'enum HoloBadgeType' = 'NOT FOUND'
'enum PlatformClientAction' = 'NOT FOUND'
'enum Method' = 'NOT FOUND'
'message RegisterBackgroundDeviceActionProto' = 'NOT FOUND'
'message AssetDigestRequestProto' = 'NOT FOUND'
'message DownloadUrlRequestProto' = 'NOT FOUND'
'message DownloadUrlOutProto' = 'NOT FOUND'
'message CollectDailyDefenderBonusProto' = 'NOT FOUND'
'message CollectDailyDefenderBonusOutProto' = 'NOT FOUND'
'message CaptureScoreProto' = 'NOT FOUND'
'message ClientFortModifierProto' = 'NOT FOUND'
'message FortRecallProto' = 'NOT FOUND'
'message FortRecallOutProto' = 'NOT FOUND'
'message PokemonCameraAttributesProto' = 'NOT FOUND'
'message PokemonEncounterAttributesProto' = 'NOT FOUND'
'message PokemonStatsAttributesProto' = 'NOT FOUND'
'message FormProto' = 'NOT FOUND'
'message ClientGenderProto' = 'NOT FOUND'
'message ClientGenderSettingsProto' = 'NOT FOUND'
'message GameMasterClientTemplateProto' = 'NOT FOUND'
'message GetGameMasterClientTemplatesProto' = 'NOT FOUND'
'message GetGameMasterClientTemplatesOutProto' = 'NOT FOUND'
'message GetRemoteConfigVersionsProto' = 'NOT FOUND'
'message GetRemoteConfigVersionsOutProto' = 'NOT FOUND'
'message ClientMapCellProto' = 'NOT FOUND'
'message GymStartSessionProto' = 'NOT FOUND'
'message GymStartSessionOutProto' = 'NOT FOUND'
'message GymBattleAttackProto' = 'NOT FOUND'
'message GymBattleAttackOutProto' = 'NOT FOUND'
'message ParticipationProto' = 'NOT FOUND'
'message HoloInventoryKeyProto' = 'NOT FOUND'
'message HoloInventoryItemProto' = 'NOT FOUND'
'message FortSponsor' = 'NOT FOUND'
'message FortRenderingType' = 'NOT FOUND'
'message PokemonProto' = 'NOT FOUND'
'message ItemProto' = 'NOT FOUND'
'message PokemonFamilyProto' = 'NOT FOUND'
'message RaidEncounterProto' = 'NOT FOUND'
'message DeploymentTotalsProto' = 'NOT FOUND'
'message InventoryProto' = 'NOT FOUND'
'message TemplateVariable' = 'NOT FOUND'
'message ClientInbox' = 'NOT FOUND'
'message Notification' = 'NOT FOUND'
'message ApnToken' = 'NOT FOUND'
'message GcmToken' = 'NOT FOUND'
'message OptOutProto' = 'NOT FOUND'
'message PlayerProfileProto' = 'NOT FOUND'
'message GymBadges' = 'NOT FOUND'
'message JoinLobbyProto' = 'NOT FOUND'
'message JoinLobbyOutProto' = 'NOT FOUND'
'message LobbyProto' = 'NOT FOUND'
'message LeaveLobbyProto' = 'NOT FOUND'
'message LeaveLobbyOutProto' = 'NOT FOUND'
'message SetLobbyVisibilityProto' = 'NOT FOUND'
'message SetLobbyVisibilityOutProto' = 'NOT FOUND'
'message SetLobbyPokemonProto' = 'NOT FOUND'
'message SetLobbyPokemonOutProto' = 'NOT FOUND'
'message GetRaidDetailsProto' = 'NOT FOUND'
'message GetRaidDetailsOutProto' = 'NOT FOUND'
'message StartRaidBattleProto' = 'NOT FOUND'
'message StartRaidBattleOutProto' = 'NOT FOUND'
'message AttackRaidBattleProto' = 'NOT FOUND'
'message AttackRaidBattleOutProto' = 'NOT FOUND'
'message PokemonFortProto' = 'NOT FOUND'
'message PokemonSummaryFortProto' = 'NOT FOUND'
'message ClientSpawnPointProto' = 'NOT FOUND'
'message ClientPlayerProto' = 'NOT FOUND'
'message CurrencyQuantityProto' = 'NOT FOUND'
'message PlayerLocaleProto' = 'NOT FOUND'
'message RecycleItemProto' = 'NOT FOUND'
'message RecycleItemOutProto' = 'NOT FOUND'
'message PtcToken' = 'NOT FOUND'
'message GetActionLogRequest' = 'NOT FOUND'
'message GetActionLogResponse' = 'NOT FOUND'
'message UncommentAnnotationTestProto' = 'NOT FOUND'
'message NewsSettingProto' = 'NOT FOUND'
'message NewsProto' = 'NOT FOUND'
'message SfidaGlobalSettingsProto' = 'NOT FOUND'
'message RegisterSfidaRequest' = 'NOT FOUND'
'message RegisterSfidaResponse' = 'NOT FOUND'
'message UseItemMoveRerollProto' = 'NOT FOUND'
'message UseItemMoveRerollOutProto' = 'NOT FOUND'
'message UseItemRareCandyProto' = 'NOT FOUND'
'message UseItemRareCandyOutProto' = 'NOT FOUND'


}



$SourceData = Get-Content -Path "$($Sourcefile)"

if (Test-Path $ProtoIndexFile) {}
else {
    write-host "ProtoIndexFile is not generated. Run split_discover_protos first!" -foregroundcolor "red"
    exit
}

$writing=0

ForEach ($ProtoLine in $SourceData) {
     
    if($writing -eq 0) {
        ###### READING MODE #########
      $OrigLine = $ProtoLine
      If ($ProtoLine -match $EnumPattern -or $ProtoLine -match $MessagePattern) {  
        #enum or message line found

        #Use above mapping table to match actual protos files on disk
        $lookupTable.GetEnumerator() | ForEach-Object {
            if ($ProtoLine -eq $_.Key)
            {
                $ProtoLine = $ProtoLine -replace $_.Key, $_.Value
            }
        }

        #Do some smart renaming here, since the protos files has it own logic
        
        If ($ProtoLine -match $EnumPattern) {  
            #Message name conversion from HoloPokemonType -> PokemonType
            $ProtoLine =  $ProtoLine -replace "HoloPokemon", "Pokemon"

            #Message name conversion from HoloPokemonType -> PokemonType
            $ProtoLine =  $ProtoLine -replace "HoloItem", "Item"

        }

        #echo $Line
      
      
        #Find the location of this element in database file
        $ProtoDB = Get-Content -Path "$($ProtoIndexFile)"
        $ProtoFile = "";
        $ProtoFileFound = 0;
        
        ForEach ($ProtoDBLine in $ProtoDB) {
          If ($ProtoFileFound -eq 1) {  
            #We found the correct file to update
                $ProtoFile = $ProtoDBLine;
                break
          }Else {}
          If ($ProtoDBLine -eq $ProtoLine) {  
            #We found the correct file to update
                $ProtoFileFound = 1;
          }Else {}
          
        }  #End ForEach

        if ($ProtoFileFound -eq 0) {
            #If we didn't find it in the first run, we can try different message conversion  now

            #Message name conversion from GymDisplayMessage -> GymDisplay
            $ProtoLine =  $ProtoLine -creplace "Message", ""
            
            #Find the location of this element in database file
            $ProtoDB = Get-Content -Path "$($ProtoIndexFile)"
            $ProtoFile = "";
            $ProtoFileFound = 0;
            
            ForEach ($ProtoDBLine in $ProtoDB) {
              If ($ProtoFileFound -eq 1) {  
                #We found the correct file to update
                    $ProtoFile = $ProtoDBLine;
                    break
              }Else {}
              If ($ProtoDBLine -eq $ProtoLine) {  
                #We found the correct file to update
                    $ProtoFileFound = 1;
              }Else {}
              
            }  #End ForEach
            
        }
        else {}

        
        if ($ProtoFileFound -eq 0) {
            #If we didn't find it in the first run, we can try different message conversion  now
            If ($ProtoLine -match $MessagePattern) {  
                #Message name conversion from CollectDailyBonusOutProto -> GymDeployMessage
                $ProtoLine =  $ProtoLine -replace "OutProto", "Response"

                #Message name conversion from CollectDailyBonusOutProto -> GymDeployMessage
                $ProtoLine =  $ProtoLine -replace "RequestProto", "Message"

                #Message name conversion from GymDeployProto -> GymDeployMessage
                $ProtoLine =  $ProtoLine -replace "Proto", "Message"
            }

            #Find the location of this element in database file
            $ProtoDB = Get-Content -Path "$($ProtoIndexFile)"
            $ProtoFile = "";
            $ProtoFileFound = 0;
            
            ForEach ($ProtoDBLine in $ProtoDB) {
              If ($ProtoFileFound -eq 1) {  
                #We found the correct file to update
                    $ProtoFile = $ProtoDBLine;
                    break
              }Else {}
              If ($ProtoDBLine -eq $ProtoLine) {  
                #We found the correct file to update
                    $ProtoFileFound = 1;
              }Else {}
              
            }  #End ForEach
            
        }
        else {}        
        


        if ($ProtoFileFound -eq 0) {
            #If we didn't find it in the first run, we can try different message conversion  now

            #Message name conversion from GymDisplayMessage -> GymDisplay
            $ProtoLine =  $ProtoLine -creplace "Message", ""
            
            #Find the location of this element in database file
            $ProtoDB = Get-Content -Path "$($ProtoIndexFile)"
            $ProtoFile = "";
            $ProtoFileFound = 0;
            
            ForEach ($ProtoDBLine in $ProtoDB) {
              If ($ProtoFileFound -eq 1) {  
                #We found the correct file to update
                    $ProtoFile = $ProtoDBLine;
                    break
              }Else {}
              If ($ProtoDBLine -eq $ProtoLine) {  
                #We found the correct file to update
                    $ProtoFileFound = 1;
              }Else {}
              
            }  #End ForEach
            
        }
        else {}

        #USE LAST
        if ($ProtoFileFound -eq 0) {
            #If we didn't find it in the 2nd run, we can try different message conversion  now

            #Message name conversion from AssetDigestRequest -> GetAssetDigestMessage
            $ProtoLine =  $ProtoLine -creplace "Request", "Message"
            $ProtoLine =  $ProtoLine -creplace "message ", "message Get"
            
            #Find the location of this element in database file
            $ProtoDB = Get-Content -Path "$($ProtoIndexFile)"
            $ProtoFile = "";
            $ProtoFileFound = 0;
            
            ForEach ($ProtoDBLine in $ProtoDB) {
              If ($ProtoFileFound -eq 1) {  
                #We found the correct file to update
                    $ProtoFile = $ProtoDBLine;
                    break
              }Else {}
              If ($ProtoDBLine -eq $ProtoLine) {  
                #We found the correct file to update
                    $ProtoFileFound = 1;
              }Else {}
              
            }  #End ForEach
            
        }
        else {}


        if ($ProtoLine -eq "NOT FOUND") {
            #We know this is not here, so skip
        }
        Else {
            if ($ProtoFileFound -eq 0) {
                write-host "Did not find:" $OrigLine " - Skipping"
                
                #This command writes the output for table above
                #write-host "'$($OrigLine)' = 'NOT FOUND'" -foregroundcolor "red"
            }
            else {
                write-host "Let's write " $ProtoLine "to " $ProtoFile "`r`n"
                
                #Generate output file name 
                #E:\Projecten\GIT Repos\POGOProtos\goedzo\src\POGOProtos\Map\Fort\FortType.proto
                
                #echo $ProtoFile
                #echo $SrcFolder
                #echo $OutPath
                $Outfile = $ProtoFile
                $Outfile = $Outfile -creplace [Regex]::Escape($SrcFolder), $OutPath
                
                
                #Create output file
                New-Item $OutFile -type file -force
                Add-Content -Path "$OutFile" -Value "syntax = ""proto3"";"

                #Determine Package
                #POGOProtos\Map\Fort\FortType.proto ->
                #package POGOProtos.Map.Fort;
                $Package = $ProtoFile -replace [Regex]::Escape($SrcFolder),""
                $Package = $Package.Substring(0, $Package.lastIndexOf('\'))
                $Package = $Package.Substring(1, $Package.Length-1)
                $Package = $Package -creplace "\\","."
                $Package = "package $($Package);"
                
                Add-Content -Path "$OutFile" -Value $Package

                Add-Content -Path "$OutFile" -Value ""

                Add-Content -Path "$OutFile" -Value $ProtoLine

                $writing=1
                
            }
        }
        
        
        
        } Else {}
    } 
    else {
    
        Add-Content -Path "$OutFile" -Value $ProtoLine

        ###### WRITING MODE #########
        if ($ProtoLine -eq "}") {
                $writing=0
        }
    }
}  #End ForEach