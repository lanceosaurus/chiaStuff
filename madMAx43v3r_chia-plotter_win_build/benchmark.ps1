Write-Host '#################'
Write-Host '# Starting madmax benchmark v0.2'
Write-Host '#'
Write-Host '# Make sure you have plenty of space on your destination drive and that your tmp drives have 250GB free.'
Write-Host '#################'

$farmerKey = '[PUT YOUR KEY HERE]'
$poolKey = '[PUT YOUR KEY HERE]'

$drives = @('G:\ChiaTmp\', 'F:\ChiaTmp\', 'K:\ChiaTmp\')
$buckets = @(32, 64, 128, 256, 512)
$destDrive = 'E:\ChiaPlots\'
$defaultDrive =  'F:\ChiaTmp\'

$threadMin = 2
$threadMax = 40
$threadStep = 2

$combineBucketsAndThreads = 'true' ## setting this to false will only run 35 times
$runcount = 1

## Note that these default variables need to be customized for you.
## This current setup runs 110 times.  About 5 days!


#######################
# Functions
#######################

function TestBuckets {
 param( [int]$threadCount)


	Write-Host '****************'
	Write-Host '* Starting bucket ladder'
	Write-Host '****************'


	# Perform iteration to create the same file in each folder
	foreach ($b in $buckets) {

		Write-Host '-----------'
		Write-Host "Buckets: $b - $runcount"
		Write-Host '-----------'
		
		Write-Host ".\chia_plot -r $threadCount -u $b -t $defaultDrive -2 $defaultDrive  -d $destDrive -f $farmerKey -p $poolKey"
		.\chia_plot -r $threadCount -u $b -t $defaultDrive -2 $defaultDrive  -d $destDrive -f $farmerKey -p $poolKey
		Write-Host '^^^'
		$runcount++
	}
	return $runcount
}
#######################
# End Functions
#######################





##only do this if you have more than one drive
if($drives.length -gt 1){
	
	Write-Host '****************'
	Write-Host '* Starting drive ladder to find your fastest drive combo.'
	Write-Host '****************'

	foreach ($d in $drives) {
		foreach ($d2 in $drives) {
			Write-Host '-----------'
			Write-Host "Temp 1: $d Temp 2: $d2 - $runcount"
			Write-Host '-----------'
			

			Write-Host ".\chia_plot -r 4 -t $d -2 $d2 -d $destDrive -f $farmerKey -p $poolKey"
			.\chia_plot -r 4 -t $d -2 $d2 -d $destDrive -f $farmerKey -p $poolKey
			Write-Host '^^^'
			$runcount++
		}
	}
}

##threads and buckets are optionally combined by the $combineBucketsAndThreads variable
Write-Host '****************'
Write-Host '* Starting Thread ladder.'
Write-Host '****************'



for ($num = $threadMin ; $num -le $threadMax; $num = $num + $threadStep){
	
	Write-Host '-----------'
	Write-Host "Threads: $num - $runcount"
	Write-Host '-----------'

	if($combineBucketsAndThreads -eq 'true'){
		$runcount = TestBuckets -threadCount $num
	}else{
		Write-Host ".\chia_plot -r $num -t $defaultDrive -2 $defaultDrive  -d $destDrive -f $farmerKey -p $poolKey"
		.\chia_plot -r $num -t $defaultDrive -2 $defaultDrive  -d $destDrive -f $farmerKey -p $poolKey
		Write-Host '^^^'
		$runcount++
	}
}


##if the buckets should run separately from the threads
if($combineBucketsAndThreads -ne 'true'){
	$runcount = TestBuckets -threadCount 4
}







Write-Host '#################'
Write-Host "# Completed: $runcount times."
Write-Host '#'
Write-Host '# Now look at all of that glorious data to see the best setting for your machine.'
Write-Host '#################'

read-host “Press ENTER to finish...”