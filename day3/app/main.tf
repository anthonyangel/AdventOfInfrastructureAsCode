locals {
  length          = length(var.items)
  half            = local.length / 2
  first_half      = split("", substr(var.items, 0, local.half))
  second_half     = split("", substr(var.items, -local.half, local.half))
  unique          = [for u in setintersection(local.first_half, local.second_half) : u][0]
  unique_priority = var.priorities[local.unique]
}

output "app" {
  value = {
    unique_priority = local.unique_priority
  }
}