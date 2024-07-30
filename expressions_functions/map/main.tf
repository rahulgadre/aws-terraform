    variable "players" {
      type = map(string)
      default = {
        "41" = "Rice"
        "8" = "Odegaard"
        "7" = "Saka"
      }
    }
     
    output "fav_player" {
      value = var.players["41"]
    }
