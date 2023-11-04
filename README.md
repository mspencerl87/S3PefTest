This is a powershell scripted call S3PerfTest
To use this script, remember to edit the following information.

# Credentials
$accesskey = "InsertAccessKey"
$secretkey = "InsertSecretKey"
$endpointurl = "Insert S3 API Endpoint URL example s3.wasabisys.com"

To change the data generated please edit 
# Generate 5GB worth of 1MiB compressed files
$numberOfFiles = 5000 # 5GB in 1MiB files
$randomData = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$fileSize = 1MB

By default we are generating 5GB worth of 1MiB files, and uploading them to our S3 of choice.
Then we calculate the time taken, and throughput in MB/s
