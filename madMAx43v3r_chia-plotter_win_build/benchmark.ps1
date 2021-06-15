Write-Host '#################'
Write-Host '# Starting madmax benchmark v0.1'
Write-Host '#################'

Write-Host '****************'
Write-Host '* Starting Thread ladder.'
Write-Host '****************'



for ($num = 2 ; $num -le 40 ; $num = $num+2){
	Write-Host "## $num threads using G:"
	.\chia_plot -r $num -t G:\ChiaTmp\ -2 G:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}
}




Write-Host '****************'
Write-Host '* Starting bucket ladder'
Write-Host '****************'


# Create an array of buckets
$buckets = @(32, 64, 128, 256, 512)

# Perform iteration to create the same file in each folder
foreach ($i in $buckets) {
    Write-Host "########"
	Write-Host "## $num buckets"
	Write-Host "########"
	
	.\chia_plot -r 8 -u $num -t G:\ChiaTmp\ -2 G:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}
}




Write-Host '****************'
Write-Host '* Starting drive ladder.'
Write-Host '****************'

Write-Host '## Both G drive'
.\chia_plot -r 8 -t G:\ChiaTmp\ -2 G:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## Both F drive'
.\chia_plot -r 8 -t F:\ChiaTmp\ -2 F:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## Both K drives'
.\chia_plot -r 8 -t K:\ChiaTmp\ -2 K:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## G and F drive'
.\chia_plot -r 8 -t G:\ChiaTmp\ -2 F:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## G and K drive'
.\chia_plot -r 8 -t G:\ChiaTmp\ -2 K:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## K and F drive'
.\chia_plot -r 8 -t K:\ChiaTmp\ -2 F:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}

Write-Host '## K and G drive'
.\chia_plot -r 8 -t K:\ChiaTmp\ -2 G:\ChiaTmp\ -d E:\chiaPlots\ -f {your farmer key} -p {your pool key}
