module "my_ip" {
  source = "git::https://github.com/pacphi/dummy-private-tf-repo.git//modules/fetch-ip"
}

output "my_ip" {
  value = module.my_ip.ip_address
}