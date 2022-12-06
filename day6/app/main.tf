locals {
  test = length(distinct(split("", var.input))) == var.marker_length ? true : false
}

output "module" {
  value = {
    answer_bool  = local.test
    input_string = var.input
    answer_value = var.incrementer + var.marker_length
  }
}