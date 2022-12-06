locals {
  starting_value = var.start * 1000
  range          = range(local.starting_value, local.starting_value + 999)
}

output "range" {
  value = local.range
}