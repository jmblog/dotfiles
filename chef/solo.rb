file_cache_path           "/tmp/chef-solo"
data_bag_path             ENV['HOME'] + "/.dotfiles/chef/data_bags"
encrypted_data_bag_secret ENV['HOME'] + "/.dotfiles/chef/data_bag_key"
cookbook_path             [ ENV['HOME'] + "/.dotfiles/chef/site-cookbooks",
                            ENV['HOME'] + "/.dotfiles/chef/cookbooks" ]
role_path                 ENV['HOME'] + "/.dotfiles/roles"
