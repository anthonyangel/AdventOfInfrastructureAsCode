locals {
  input_file                  = templatefile("${path.module}/input.txt", {})
  rucksacks                   = split("\n", local.input_file)
  lowercase_alphabet_string   = "abcdefghijklmnopqrstuvwxyz"
  lowercase_alphabet_list     = split("", local.lowercase_alphabet_string)
  uppercase_alphabet_list     = split("", upper(local.lowercase_alphabet_string))
  lowercase_alphabet_priority = { for index, l in local.lowercase_alphabet_list : l => (index + 1) }
  uppercase_alphabet_priority = { for index, l in local.uppercase_alphabet_list : l => (index + 27) }
  priority                    = merge(local.lowercase_alphabet_priority, local.uppercase_alphabet_priority)
  priorities                  = { for k, v in module.rucksack : k => v.app.unique_priority }
  total_priorities            = sum([for k, v in local.priorities : v])
  groups                      = chunklist(local.rucksacks, 3)
  group_priorities            = { for k, v in module.groups : k => v.app.unique_priority }
  total_group_priorities      = sum([for k, v in local.group_priorities : v])
}

module "rucksack" {
  for_each   = toset(local.rucksacks)
  source     = "./app"
  items      = each.key
  priorities = local.priority
}

module "groups" {
  for_each   = { for k, v in chunklist(local.rucksacks, 3) : k => v }
  source     = "./app2"
  items      = each.value
  priorities = local.priority
}

output "output" {
  value = local.total_group_priorities
}