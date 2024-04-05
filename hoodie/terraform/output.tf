output "db_main_uri" {
  value = "Database running at: mysql://${aws_eip.ubuntu-mariadb.public_ip}:3306"
}

output "backend_main_uri" {
  value = "Backend status: http://${aws_eip.ubuntu-backend.public_ip}:8082/catalogue/health"
}

output "frontend_main_uri" {
  value = "Frontend available at: http://${aws_eip.ubuntu-frontend.public_ip}:3000"
}