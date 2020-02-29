
data "vsphere_datacenter" "dc"{
  name = "Cypress 2 DataCenter"
}

data "vsphere_datastore" "datastore" {
  name          = "nfs_vsphere_cyp_03"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "vKube"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "NonProd_Servers (VLAN 80)"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu.16.04.thin"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

####################################################################
# State the name scheme of the VM's - note the count index 
####################################################################
resource "vsphere_virtual_machine" "Terraform" {
  name             = "swcyp2k8ng02${count.index}.kaplaninc.com"
  count			       =  8
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder          = "vKube"

####################################################################
# Choose your VM's - dont kill your box... 
  num_cpus = 2
  memory   = 6144
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    #eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
####################################################################
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "swcyp2k8ng02${count.index}"
        domain    = "kaplaninc.com"
      }

      
	  network_interface {
 
      }

      #ipv4_gateway = "192.168.1.1"
    }
  }
}