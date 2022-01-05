$folder = "c:\temp"
$log = "c:\temp\AwesomeFile.txt"
$date = get-date

if (!(Test-Path $log)) {
    New-Item -Path $folder -ItemType Directory
    New-Item -Path $log -ItemType File
    Add-Content -Value "Awesome Content - $date" -Path $log
    }
else {
    Add-Content -Value "Some More Awesome Content - $date" -Path $log
}