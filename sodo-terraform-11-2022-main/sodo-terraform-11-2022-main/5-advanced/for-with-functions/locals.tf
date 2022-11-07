locals {
  groups = {
    group1 = {
      name = "group 1"
      repo = "repo 1"
      members = [
        "alex",
        "barbara",
      ]
    }
    group2 = {
      name = "group 2"
      repo = "repo 2"
      members = [
        "carrie",
        "dave",
        "barbara",
      ]
    }
  }
}

output "input_groups" {
  value = local.groups
}

locals { # let's just get only groups and their members
  groups_with_members = {
    for key, group in local.groups :
    key => group.members
  }
}

output "groups_with_members" {
  value = local.groups_with_members
}

locals { # we have a set of groups with many members, let's revert to members with their groups
  members_in_groups = transpose(local.groups_with_members)

  group_members = transpose({
    for key, group in local.groups :
    key => group.members
  })
}

output "members_in_groups" {
  value = local.members_in_groups
}

locals {
  every_member_separately = [
    for member, groups in local.group_members : [
      for group in groups : {
        group  = group
        member = member
      }
    ]
  ] # but barbara will cause a list of two elements!

  # every_member_separately is a list of lists, so let's just have one list of every membership as an element
  every_membership_separately = flatten(local.every_member_separately)
}

output "every_member_separately" {
  value = local.every_member_separately
}

output "every_membership" {
  value = flatten([
    for member, groups in local.group_members : [
      for group in groups : {
        group  = group
        member = member
      }
    ]
  ])
}

# now we can use resources that are for EVERY user as many times as they are in the groups


# Now, easy part is to do that all from a group perspective, not the user:

locals {
  list_from_groups = flatten([
    for key, group in local.groups : [
      for member in group.members : {
        group  = key
        member = member
      }
    ]
  ])
}

output "list" {
  value = local.list_from_groups
}

locals {
  map_from_list = {
    for membership in local.list_from_groups :
    "${membership.group}-${membership.member}" => membership
  }
}

# now we can use it as a resources for_each (map or sets of string)
