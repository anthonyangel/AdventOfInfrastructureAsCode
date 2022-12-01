locals {
  input_file = templatefile("${path.module}/input.txt", {})
  input_string = tostring(local.input_file)
  input_list = split("\n",local.input_string)
  stringified_input_list = join(",", local.input_list)
  new_list = split(",,",local.stringified_input_list)
  values = [ for v in local.new_list : sum(split(",", v)) ]
  sorted_strings = reverse(sort([for n in local.values : format("%09d", n)]))
  sorted_numbers   = [for s in local.sorted_strings : tonumber(s)]
  last_3 = sum(slice(local.sorted_numbers,0,3))
  max = max(local.values...)
}

output "max" {
    value = local.max
}

output "last_3" {
    value = local.last_3
}