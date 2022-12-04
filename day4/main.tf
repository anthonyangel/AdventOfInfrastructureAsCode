locals {
  input_file              = templatefile("${path.module}/input.txt", {})
  pairs                   = split("\n", local.input_file)
  all_pairs               = { for k, v in module.pairs : k => v.pairs }
  overlapping_range       = { for k, v in module.pairs : k => v.pairs if v.pairs.overlapping_range == true }
  overlapping_range_count = length(local.overlapping_range)
  any_overlap             = { for k, v in module.pairs : k => v.pairs if v.pairs.any_overlap == true }
  any_overlap_count       = length(local.any_overlap)
}

module "pairs" {
  for_each = { for index, v in local.pairs : index => v }
  source   = "./app"
  first = {
    min = min(split("-", split(",", each.value)[0])...)
    max = max(split("-", split(",", each.value)[0])...)
  }
  second = {
    min = min(split("-", split(",", each.value)[1])...)
    max = max(split("-", split(",", each.value)[1])...)
  }
}

# output "all_pairs" {
#   value = local.all_pairs
# }

output "overlapping_range_count" {
  value = local.overlapping_range_count
}

output "any_overlap_count" {
  value = local.any_overlap_count
}