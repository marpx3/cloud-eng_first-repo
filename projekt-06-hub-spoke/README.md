### Summary
Erste vollständige Umgebung. 
Ziel Hub-Spoke Umgebung, Peering, NSGs, Storage Account mir private Endpoint und VM Jumphost um das interne routing des Storage Accounts zu prüfen. 

1. Hub-Spoke
Hub und Spoke resourcen über module erstellt
-> Zusammenfassen von struktur gleichen resourcen als Modul. In diesem Beispiel Module Hub, besteht aus den reourcen virtual_network und subnet

2. Peering
Peering muss in beide Richtungen erfolgen.
zugriff auf module Eigentschaften über anderen pfad -> Bsp. module.hub.vnet_id

3. NSGs
Besteht in der Regel aus 3 resourcen: Network_security_group, Network_security_Rule und network_security_assosciation

4. Storage Account mit Private Endpoint
Besteht aus: 
Storage Account, 
Private DNS Zone (name muss hier immer "privatelink.blob.core.windows.net" sein ) 
2x private_dns_zone_virtual_network_link -> Link zu den vnets
private_endpoint" "blob" -> NIC mit private IP im Subnet die den Storage ins eigene Netz holt

5. Jump Host
Azure VM mit Public Ip und ssh Freigabe (auf meine IP)
NIC mit verlinkung ins hub subnet
Entscheidung gegen Bastion aufgrund der Kosten, Security für eine LAB Umgebung reicht auch so aus. 