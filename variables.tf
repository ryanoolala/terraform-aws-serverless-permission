/* User creation */
variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "users" {
  description = "A map users to create"
  type = map(object({
    description          = string
    name                 = string
    permissions_boundary = string
    username             = string
    pgp_key              = string
  }))
  default = {}

  /* Example
    users = {
      description = ""
      name = "Firstname Lastname"
      permissions_boundary = ""
      username = "default-username"
      pgp_key = ""
    }
  */
}
