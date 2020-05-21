# First , deploy the VM with a diskSizeGB of 42
    # Deploy : ProvisioningState Succeeded !
    New-AzResourceGroupDeployment `
    -ResourceGroupName "test" `
    -TemplateFile ..\tmpl\azuredeploy.42.json `
    -TemplateParameterFile ..\tmpl\azuredeploy.parameters.json 
    Pause

# Then , redeploy/update the VM with a diskSizeGB of 50
    # Deploy : ProvisioningState Failed !
    New-AzResourceGroupDeployment `
    -ResourceGroupName "test" `
    -TemplateFile ..\tmpl\azuredeploy.50.json `
    -TemplateParameterFile ..\tmpl\azuredeploy.parameters.json 
    Pause
    <#
        # First Error 
        "error": {
            "code": "Conflict",
            "message": "Disk resizing is allowed only when creating a VM or when the VM is deallocated.",
            "target": "disk.diskSizeGB"
        }

        # Second Error after Stopping the the VM
        "error": {
            "code": "ResizeDiskError",
            "message": "Managed disk resize via Virtual Machine 'simpleLinuxVM' is not allowed. Please resize disk resource at /subscriptions/74e40b38-b6d3-41e9-8e10-c9c61be0e198/resourceGroups/test/providers/Microsoft.Compute/disks/simpleLinuxVM_disk1_d0d4a394e221442583e9099429c15f73.",
            "target": "disk.diskSizeGB"
        }
    #>

# Then, resize the disk using this code :
    # https://docs.microsoft.com/en-us/azure/virtual-machines/windows/expand-os-disk
    #Connect-AzAccount
    #Select-AzSubscription -SubscriptionName 'Visual Studio Enterprise'
    $rgName = 'test'
    $vmName = 'simpleLinuxVM'
    $vm = Get-AzVM -ResourceGroupName $rgName -Name $vmName
    Stop-AzVM -ResourceGroupName $rgName -Name $vmName
    $disk= Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
    $disk.DiskSizeGB = 50
    Update-AzDisk -ResourceGroupName $rgName -Disk $disk -DiskName $disk.Name
    Start-AzVM -ResourceGroupName $rgName -Name $vmName
    Pause

# And finaly , redeploy/update the VM with a diskSizeGB of 50
    # Deploy : ProvisioningState Succeeded !
    New-AzResourceGroupDeployment `
    -ResourceGroupName "test" `
    -TemplateFile ..\tmpl\azuredeploy.50.json `
    -TemplateParameterFile ..\tmpl\azuredeploy.parameters.json 