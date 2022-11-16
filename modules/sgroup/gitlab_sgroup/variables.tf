
######################################################################
#Set Up Existing Git Server
######################################################################
variable "git_info"{
  type = map(string)
  default = ({
    user = "yunan"
    token = ""
  })
}
variable "gitlab_instance"{
  default = ""
}
