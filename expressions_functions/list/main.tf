    variable "sports" {
      type = list(string)
      default = ["soccer", "cricket", "f1", "basketball"]
    }
     
    output "fav_sport" {
      value = element(var.sports, 0)
    }
