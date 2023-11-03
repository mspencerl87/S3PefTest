# Check if AWS.Tools.Common module is installed
if (-not (Get-Module -ListAvailable -Name "AWS.Tools.Common")) {
    Write-Host "AWS.Tools.Common module not found. Installing..."
    Install-Module -Name "AWS.Tools.Common" -Force -Scope CurrentUser
}

# Import the AWS.Tools.Common module
Import-Module AWS.Tools.Common

# Credentials
$accesskey = "mPm8NKztuEeXqh4xblsW"
$secretkey = "ZmkgkylMjYgKPm0OVarCmIItxoUhqxonG8zhclM7"
$endpointurl = "https://minio.spencerleb.duckdns.org"

# Set Credentials
Set-AWSCredential -AccessKey $accesskey -SecretKey $secretkey -StoreAs default

# Generate a random bucket name
$prefix = "testbucket"
$suffix = [System.Guid]::NewGuid().ToString("N").Substring(0, 10) # Generate a random 10-character suffix
$bucketName = "${prefix}-${suffix}"

# Create the S3 bucket
New-S3Bucket -BucketName $bucketName -EndpointUrl "$endpointurl"

# List buckets to verify the new bucket creation
Get-S3Bucket -EndpointUrl "$endpointurl"

# Define the path for storing generated files
$localPath = "C:\Temp\GeneratedFiles"

# Create the local directory for generated files
New-Item -Path $localPath -ItemType Directory -Force

# Generate 5GB worth of 1MiB compressed files
$numberOfFiles = 1000 # 5GB in 1MiB files
$randomData = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$fileSize = 1MB

for ($i = 1; $i -le $numberOfFiles; $i++) {
    $fileContent = New-Object byte[] $fileSize
    $randomData.GetBytes($fileContent)
    $filePath = Join-Path $localPath ("file$i.dat")
    [System.IO.File]::WriteAllBytes($filePath, $fileContent)
}

# Upload the generated files to the S3 bucket
$uploadStartTime = Get-Date
Write-S3Object -BucketName $bucketName -Directory $localPath -KeyPrefix "uploaded-files" -EndpointUrl $endpointurl
$uploadEndTime = Get-Date

# Calculate the data transferred and the transfer speed
$dataTransferred = [math]::Round((Get-ChildItem $localPath -File | Measure-Object -Sum Length).Sum / 1MB, 2)
$uploadDuration = ($uploadEndTime - $uploadStartTime).TotalSeconds
$transferSpeed = [math]::Round(($dataTransferred / $uploadDuration), 2)

# Print the report
Write-Host "Data Transferred: $dataTransferred MB"
Write-Host "Transfer Speed: $transferSpeed MB/s"
