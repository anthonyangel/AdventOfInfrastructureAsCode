locals {
  one             = split("", var.items[0])
  two             = split("", var.items[1])
  three           = split("", var.items[2])
  unique          = [for u in setintersection(local.one, local.two, local.three) : u][0]
  unique_priority = var.priorities[local.unique]
}

output "app" {
  value = {
    unique_priority = local.unique_priority
  }
}