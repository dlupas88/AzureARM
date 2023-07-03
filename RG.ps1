

$rg='demoStorageAccountRG'
New-AzResourceGroup -Name $rg -Location centralus -Force

New-AzResourceGroupDeployment `
-ResourceGroupName $rg `
-TemplateFile '.\storage01.json' `
-storageKind 'Standard_GRS' `
-WhatIf