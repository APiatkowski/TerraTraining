
resource "github_team" "group" {
  for_each    = var.groups
  name        = each.value.name
  description = each.value.description
  privacy     = "secret"
}

resource "github_repository" "group_repo" {
  for_each    = var.groups
  name        = each.value.repo
  description = "Shared code"
  auto_init   = true
  visibility  = "private"
  #gitignore_template = "Terraform"
}

resource "github_team_repository" "group_repo_attach" {
  for_each   = var.groups
  team_id    = github_team.group[each.key].id
  repository = github_repository.group_repo[each.key].name
  permission = "admin" # pull | push | admin
}

# every member for any group means that we need pairs: group1-member1, group1-member2, group2-member1, group2-member3 with their information

resource "github_team_membership" "group_members" {
  for_each = # TODO

  team_id  = # TODO
  username = # TODO
  role     = "member" # or "maintainer"
}