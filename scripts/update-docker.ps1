# PowerShell script to update Termux Package Builder Docker Image
#
# Usage example:
#
# .\scripts\update-docker.ps1

Set-Variable -Name CONTAINER -Value "termux-package-builder"
Set-Variable -Name IMAGE -Value "termux/package-builder"

docker pull $IMAGE

Set-Variable -Name LATEST -Value (docker inspect --format "{{.Id}}" $IMAGE)
Set-Variable -Name RUNNING -Value (docker inspect --format "{{.Image}}" $CONTAINER)

if ($LATEST -eq $RUNNING) {
    Write-Output "Image '$IMAGE' used in the container '$CONTAINER' is already up to date"
} else {
    Write-Output "Image '$IMAGE' used in the container '$CONTAINER' has been updated - removing the outdated container"
    docker stop $CONTAINER
    docker rm -f $CONTAINER
}
