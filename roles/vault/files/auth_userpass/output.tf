output "admin_pass" {
  sensitive = true
  value     = random_password.password.result
}


