$subs = Get-AzureRmSubscription
$Udrs = @()
"$("Subscription"), $("VNET name"), $("VNET Prefix"), $("Resource Group name"), $("Subnet name"), $("Subnet Prefix"), $("UDR name")" | Out-File -Append .\VNETs.csv -Encoding UTF8
"$("UDR Name"), $("Route Name"), $("Prefix"), $("Gateway type"), $("Gateway address")" | Out-File -Append .\UDRs.csv -Encoding UTF8
foreach ($Sub in $Subs) {
	$SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name
	$VNETs = Get-AzureRmVirtualNetwork
	foreach ($VNET in $VNETs) {
		# Write-Output ( $Sub.Name, $VNET.Name, ($VNET).AddressSpace.AddressPrefixes) # | convertto-csv -NoTypeInformation
        $Subnets = $VNET | Get-AzureRmVirtualNetworkSubnetConfig
        foreach ($Subnet in $Subnets) {
            if ([string]::IsNullOrEmpty($Subnet.RouteTable.Id)) {
            $UdrName="None"
            }
            else {
            $UdrFull=$Subnet.RouteTable.Id.split("/")
            $UdrName=$UdrFull[$UdrFull.Count-1]
            if (-Not ($Udrs.Contains($UdrName))) {
                $Udrs += $UdrName
                Write-Output "Adding UDR $UdrName"
            $UdrRg= $UdrFull[4]
            # 
            $Table = Get-AzureRmRouteTable -ResourceGroupName $UdrRg -Name $UdrName
            "$($UdrName), $("#####") , $("#####"), $("#####"), $("#####")" | Out-File -Append .\UDRs.csv -Encoding UTF8
            foreach ($route in $Table.Routes)
             {
                # $routes += $route.Name # $i.Name
                # Write-Output ($route.Name, $route.AddressPrefix, $route.NextHopType, $route.NextHopIpAddress)
                "$($UdrName), $($route.Name), $($route.AddressPrefix), $($route.NextHopType), $($route.NextHopIpAddress) " | Out-File -Append .\UDRs.csv -Encoding UTF8
                
             }
                }
            }
            
            # Write-Output ( $Subnet.name, $Subnet.AddressPrefix, $UdrName)
            "$($Sub.Name), $($VNET.Name), $(($VNET).AddressSpace.AddressPrefixes), $($UdrRg), $($Subnet.name), $($Subnet.AddressPrefix), $($UdrName)" | Out-File -Append .\VNETs.csv -Encoding UTF8
            
        }
	}
}
