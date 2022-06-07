#--------------------------------------------------------------
# module variables
#--------------------------------------------------------------
variable "users" {
  type = map(object(
    {
      key_name            = string
      private_key_openssh = string
      instance_id         = string
    }
  ))
  description = "(Required) Variables to set what is needed as user setting information."
}
