cookbook_path    ["chef/cookbooks", "chef/site-cookbooks"]
node_path        "chef/nodes"
role_path        "chef/roles"
environment_path "chef/environments"
data_bag_path    "chef/data_bags"

knife[:ssh_user]       = "ec2-user"
