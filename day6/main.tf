# Terraform ranges don't support >1024 values, so I'm constructing my own
module "ranger" {
  source = "./ranger"
  count  = ceil(local.input_length / 999)
  start  = count.index
}

locals {
  input         = templatefile("${path.module}/input.txt", {})
  input_length  = length(local.input)
  marker_length = 4
  big_range     = concat(flatten([for k, v in module.ranger : flatten(v["range"])]))
}

module "app" {
  source        = "./app"
  for_each      = { for k, v in toset(local.big_range) : k + 1 => tostring(v + 1) }
  input         = substr(local.input, each.value, local.marker_length)
  incrementer   = each.value
  marker_length = local.marker_length
}

output "answer" {
  value = min([for k, v in module.app : v["module"]["answer_value"] if v["module"]["answer_bool"] == true]...)
}

