# vCenter connection

variable "vsphere_user" {
  description = "vSphere user name"
  default     = "private"
}

variable "vsphere_password" {
  description = "vSphere password"
  default     = "private"
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
  default     = "private"
}

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
  default     = "private"
}


