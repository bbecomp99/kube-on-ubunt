
data "vsphere_datacenter" "dc"{
  name = "******nter"
}

data "vsphere_datastore" "datastore" {
  name          = "*******"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "vKube"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "No*********"
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
  name             = "sw******02${count.index}.p***.com"
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
        host_name = "sw*****ng02${count.index}"
        domain    = "ya*****nc.com"
      }

      
	  network_interface {
 
      }

      #ipv4_gateway = "192.168.1.1"
    }
  }
}
