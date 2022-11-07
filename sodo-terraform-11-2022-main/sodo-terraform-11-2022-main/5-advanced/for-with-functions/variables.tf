variable "groups" {
  type = map(
    object({
      name = string
      repo = string
      description = string
      members = list(string)
    })
  )
  default = {}
  description = "Groups structure"
}