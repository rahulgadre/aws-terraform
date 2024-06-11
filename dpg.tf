provider "vsphere" {
  user           = "administrator@vsphere.local"  
  password       = "PWD"
  vsphere_server = "mainpod-vcenter.acp.avaya.com"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "ASP4200"
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = "DSwitch0"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


resource "vsphere_distributed_port_group" "pg" {
  name                            = "rgg-DPG"
  distributed_virtual_switch_uuid = "50 10 f8 c3 99 ad ac ee-ec 8c 47 68 14 55 b4 8f"
  vlan_id = 1234
}
