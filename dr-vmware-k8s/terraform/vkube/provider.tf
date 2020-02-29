provider "vsphere" {
  user           = "terraform@vsphere.local"
  password       = "qoCAahsgdbc76sj2#"
  vsphere_server = "vcenter01.kaplaninc.com"
  allow_unverified_ssl = true
}