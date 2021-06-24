#####from: https://thechiafarmer.com/2021/04/19/plotting-with-powershell-on-windows/
#####from: https://thechiafarmer.com/2021/04/21/optimizing-plotters-in-windows/

#Begin Script
############Plotters for Temp Drive###############

#D: & O:

##robocopy E:\chiaPlots //M0/chiaPlots /mov *.plot
##robocopy E:\chiaPlots D:\chiaPlots /mov /z /mon:2 /v /ETA *.plot

##We want to move files from multiple drives onto a single queue of drives 

$sourceArray = @('D:\chiaPlots','O:\chiaPlots','P:\chiaPlots')
$destArray = @('F:\chiaPlots','G:\chiaPlots','H:\chiaPlots')
$minSpaceInBytes = 109000000000
$minSpaceToMoveInBytes = 105000000000

Write-Host '#################################################'
Write-Host "Starting Plot copier at $((get-date))"
Write-Host '#################################################'


##endless loop
while(1 -eq 1){
	##get the next source drive from the source drive queue
	foreach ($sourceFolder in $sourceArray) {
		Write-Host '************************************'
		Write-Host "Checking $sourceFolder for any files"
		
		
		##get the list of files to move
		$plotFiles=get-childitem -path $sourceFolder -Filter *.plot | Sort CreationTime
		Write-Host "$sourceFolder has $($plotFiles.Count) file(s) to move."
		foreach($plot in $plotFiles){
			Write-Host $plot.FullName
		}
		Write-Host '************************************'
		
		foreach($plot in $plotFiles){
			Write-Host "  Looking to move $($plot.FullName)..."
		
			##get the next destination drive from the destination drive queue
			foreach ($destFolder in $destArray) {
				
				$driveLetter = $destFolder -split '\\' | select -First 1
				$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$driveLetter'" | Select-Object Size,FreeSpace
				
				if($disk.FreeSpace -gt 0){
					$freespace = [math]::Round($disk.FreeSpace/1GB,4)
					$totalspace = [math]::Round($disk.Size/1GB,4)
					$percentusedspace = [math]::Round($disk.FreeSpace/$disk.Size *100,2)
					$numberOfPlotsAvailable = [math]::Round($disk.FreeSpace / $minSpaceInBytes)
					
					Write-Host "  $destFolder can fit $numberOfPlotsAvailable more plots.  It has $freespace GB free space out of $totalspace GB total space ($percentusedspacepercentusedspace % used)"
				}
				
				##check destination drive for adequate space			
				if($disk.FreeSpace -gt $minSpaceInBytes)
				{
					##if enough space, move file to it
					
					##just grab the oldest plot
					##$plot=get-childitem -path $sourceFolder -Filter *.plot | Sort CreationTime | select -First 1  
					Write-Host "  Current plot is: $($plot.FullName) the size is: $($plot.length)"
					
					if($plot.length -gt $minSpaceToMoveInBytes)
					{
						Write-Host '  Its big enough!' -ForegroundColor Green
						
						##only move plots older than an hour 
						$timespan = new-timespan -hours 1
						if (((get-date) - $plot.lastWriteTime) -gt $timespan) {
							Write-Host '  Its old enough!' -ForegroundColor Green
							robocopy $sourceFolder $destFolder $plot.Name /Z /J /MOV /MIN:$minSpaceToMoveInBytes
							[System.Media.SystemSounds]::Asterisk.Play()
							#read-host 'Press ENTER to continue...'
							break
						}
						else{
							Write-Host '  STOP - File to too young.' -ForegroundColor Yellow
							break
						}
					}
					else{
						Write-Host '  STOP - File to too small.' -ForegroundColor Yellow
						break
					}
				}
				else{
					Write-Host "  ****STOP - FULL OR MISSING DESTINATION DRIVE - please replace $destFolder" -ForegroundColor Red
					[System.Media.SystemSounds]::Exclamation.Play()
				}			
			}
		}
	 }

	 ##sleep 5min
	 Write-host 'Sleeping...'
	Start-Sleep -Seconds 300
	[System.Media.SystemSounds]::Beep.Play()
}


