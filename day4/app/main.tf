locals {
  first                = var.first
  second               = var.second
  first_within_second  = (local.first["min"] >= local.second["min"]) && local.first["max"] <= local.second["max"]
  second_within_first  = (local.first["min"] <= local.second["min"]) && local.first["max"] >= local.second["max"]
  overlapping_range    = local.first_within_second || local.second_within_first
  first_overlap_second = (local.first["min"] >= local.second["min"]) && (local.first["min"] <= local.second["max"])
  second_overlap_first = (local.second["min"] >= local.first["min"]) && (local.second["min"] <= local.first["max"])
  any_overlap          = local.first_overlap_second || local.second_overlap_first
}

output "pairs" {
  value = {
    first = local.first
    second = local.second
    # first_within_second = local.first_within_second
    # second_within_first = local.second_within_first
    overlapping_range   = local.overlapping_range
    any_overlap         = local.any_overlap
    first_overlap_second = local.first_overlap_second
    second_overlap_first = local.second_overlap_first
  }
}