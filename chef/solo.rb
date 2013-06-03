chef_dir = File.expand_path(File.dirname(__FILE__))

file_cache_path           "/tmp/chef-solo"
data_bag_path             "#{chef_dir}/data_bags"
encrypted_data_bag_secret "#{chef_dir}/data_bag_key"
cookbook_path             [ "#{chef_dir}/site-cookbooks",
                            "#{chef_dir}/cookbooks" ]
role_path                 "#{chef_dir}/roles"
