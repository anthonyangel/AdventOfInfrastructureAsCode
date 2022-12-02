locals {
  input_file = templatefile("${path.module}/input.txt", {})
  per_round  = split("\n", local.input_file)
  per_round_map = { for index, r in local.per_round : index => {
    opponent_request = local.opponent_request[(split(" ", r)[0])]
    one_my_request   = local.one_my_request[split(" ", r)[1]]["Shape"]
    required_ending  = local.one_my_request[split(" ", r)[1]]["Required_Ending"]
    required_shape   = local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Draw" ? local.opponent_request[(split(" ", r)[0])]["Shape"] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Lose" ? local.betters[local.opponent_request[(split(" ", r)[0])]["Shape"]] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Win" ? [for k,v in local.betters : k if v == local.opponent_request[(split(" ", r)[0])]["Shape"]][0] : "Eh?"
    opponent         = local.opponent_request[(split(" ", r)[0])]["Shape"]
    me               = local.one_my_request[split(" ", r)[1]]["Shape"]
    competitors      = join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))
    inital_points    = local.one_my_request[(split(" ", r)[1])]["Points"]
    winner           = try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw")
    is_win           = try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.one_my_request[split(" ", r)[1]]["Shape"]
    is_loss          = try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.opponent_request[(split(" ", r)[0])]["Shape"]
    is_draw          = try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == "draw"
    result           = (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.one_my_request[split(" ", r)[1]]["Shape"]) ? "Win" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.opponent_request[(split(" ", r)[0])]["Shape"]) ? "Lose" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == "draw") ? "Draw" : "eh?"
    result_points    = local.weighting[(try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.one_my_request[split(" ", r)[1]]["Shape"]) ? "Win" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.opponent_request[(split(" ", r)[0])]["Shape"]) ? "Lose" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == "draw") ? "Draw" : "eh?"]
    total_points     = sum([local.one_my_request[(split(" ", r)[1])]["Points"], local.weighting[(try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.one_my_request[split(" ", r)[1]]["Shape"]) ? "Win" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == local.opponent_request[(split(" ", r)[0])]["Shape"]) ? "Lose" : (try(local.combat[join(",", sort(distinct([local.opponent_request[(split(" ", r)[0])]["Shape"], local.one_my_request[split(" ", r)[1]]["Shape"]])))], "draw") == "draw") ? "Draw" : "eh?"]])
    part_2_initial_points = local.shape_to_points[local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Draw" ? local.opponent_request[(split(" ", r)[0])]["Shape"] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Lose" ? local.betters[local.opponent_request[(split(" ", r)[0])]["Shape"]] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Win" ? [for k,v in local.betters : k if v == local.opponent_request[(split(" ", r)[0])]["Shape"]][0] : "Eh?"]
    part_2_result_points = local.weighting[(local.one_my_request[split(" ", r)[1]]["Required_Ending"])]
    part_2_total_points = sum([local.shape_to_points[local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Draw" ? local.opponent_request[(split(" ", r)[0])]["Shape"] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Lose" ? local.betters[local.opponent_request[(split(" ", r)[0])]["Shape"]] : local.one_my_request[split(" ", r)[1]]["Required_Ending"] == "Win" ? [for k,v in local.betters : k if v == local.opponent_request[(split(" ", r)[0])]["Shape"]][0] : "Eh?"], local.weighting[(local.one_my_request[split(" ", r)[1]]["Required_Ending"])]])
  } }
  combat = {
    join(",", sort(["Rock", "Scissors"]))  = "Rock",
    join(",", sort(["Rock", "Paper"]))     = "Paper",
    join(",", sort(["Paper", "Scissors"])) = "Scissors"
  }
  opponent_request = {
    A = {
      Shape = "Rock"
    }
    B = {
      Shape = "Paper"
    }
    C = {
      Shape = "Scissors"
    }
  }
  one_my_request = {
    X = {
      Shape           = "Rock"
      Points          = 1
      Required_Ending = "Lose"
    }
    Y = {
      Shape           = "Paper"
      Points          = 2
      Required_Ending = "Draw"
    }
    Z = {
      Shape           = "Scissors"
      Points          = 3
      Required_Ending = "Win"
    }
  }
  shape_to_points = {
    Rock = 1
    Paper = 2
    Scissors = 3
  }
  weighting = {
    Lose = 0
    Draw = 3
    Win  = 6
  }
  total_points = sum(flatten([for round in local.per_round_map : [round.total_points]]))
  part_2_total_points = sum(flatten([for round in local.per_round_map : [round.part_2_total_points]]))
  betters = {
    Paper    = "Rock"
    Rock     = "Scissors"
    Scissors = "Paper"
  }
}

output "total_points" {
  value = local.total_points
}

output "part_2_total_points" {
  value = local.part_2_total_points
}