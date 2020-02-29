################################################################
#You could probably call your creds in a better way, but for this 
#but whatever.

################################################################


################################################################
  # If you have a self-signed cert

################################################################

data "vsphere_datacenter" "dc"{
  name = "kapcyplabdc001"
}

data "vsphere_datastore" "datastore" {
  name          = "SSD1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "vKube"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "labnet"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "centos_ssd_thin"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

####################################################################
# State the name scheme of the VM's - note the count index 
####################################################################
resource "vsphere_virtual_machine" "Terraform" {
  name             = "kapdevk8n${count.index}"
  count			       =  10
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder          = "Labrats"

####################################################################
# Choose your VM's - dont kill your box... 
  num_cpus = 2
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    #thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
####################################################################
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "kapdevwebsrv${count.index}"
        domain    = "kaplab.edu"
      }

      
	  network_interface {
 
      }

      #ipv4_gateway = "192.168.1.1"
    }
  }
}