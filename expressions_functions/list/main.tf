    variable "cities" {
      type = list
      default = ["denver", "pittsburgh", "rochester", "canonsburg"]
    }
     
    output "fav_city" {
      value = var.cities["0"]
    }
