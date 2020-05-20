# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/expand-os-disk

#Connect-AzAccount
#Select-AzSubscription -SubscriptionName 'Visual Studio Enterprise'

$rgName = 'test2'
$vmName = 'simpleLinuxVM'

$vm = Get-AzVM -ResourceGroupName $rgName -Name $vmName
Stop-AzVM -ResourceGroupName $rgName -Name $vmName

$disk= Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$disk.DiskSizeGB = 42
Update-AzDisk -ResourceGroupName $rgName -Disk $disk -DiskName $disk.Name

Start-AzVM -ResourceGroupName $rgName -Name $vmName

