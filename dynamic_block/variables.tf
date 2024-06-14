variable "ingress_ports" {
  type        = list(number)
  description = "SG listing all inbound ports"
  default     = [443, 53, 123]
}
