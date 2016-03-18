include_recipe 'java'

omc_elasticsearch_node 'elasticsearch' do
  action :install
  home node[:omc_elasticsearch][:home]
  version node[:omc_elasticsearch][:version]
  base_url node[:omc_elasticsearch][:base_url]
  gpgkey_url node[:omc_elasticsearch][:gpgkey_url]
  cluster_name node[:omc_elasticsearch][:cluster_name]
  install_path node[:omc_elasticsearch][:install_path]
  config_path node[:omc_elasticsearch][:config_path]
  data_path node[:omc_elasticsearch][:data_path]
  log_path node[:omc_elasticsearch][:log_path]
  work_path node[:omc_elasticsearch][:work_path]
  pid_path node[:omc_elasticsearch][:pid_path]
end

omc_elasticsearch_config 'elasticsearch' do
  action :render
  cluster_name node[:omc_elasticsearch][:cluster_name]
  version node[:omc_elasticsearch][:version]
  install_path node[:omc_elasticsearch][:install_path]
  config_path node[:omc_elasticsearch][:config_path]
  data_path node[:omc_elasticsearch][:data_path]
  log_path node[:omc_elasticsearch][:log_path]
  work_path node[:omc_elasticsearch][:work_path]
  pid_path node[:omc_elasticsearch][:pid_path]
  http_port node[:omc_elasticsearch][:http_port]
  transport_port node[:omc_elasticsearch][:transport_port]
  node_name node.fqdn.downcase
  bind_ip node[:omc_elasticsearch][:bind_ip]
  publish_ip node[:omc_elasticsearch][:publish_ip]
  elasticsearch_data_bag_info node[:omc_elasticsearch][:elasticsearch_data_bag_info]
  override_java_opts node[:omc_elasticsearch][:override_java_opts]
  override_config node[:omc_elasticsearch][:override_config]
  override_sysconfig node[:omc_elasticsearch][:override_sysconfig]
end

node[:omc_elasticsearch][:plugins].each do |plugin|
  omc_elasticsearch_plugin plugin['name'] do 
    action :install
    es_home node[:omc_elasticsearch][:install_path]
    uri plugin['uri']
    arguments plugin['arguments']
  end
end

=begin
omc_elasticsearch_plugin 'kopf' do
  action :install
  es_home node[:omc_elasticsearch][:install_path]
  uri 'lmenezes/elasticsearch-kopf/master'
  #arguments '-DproxyHost=www-proxy.us.oracle.com -DproxyPort=80 --verbose'
  arguments 'DproxyHost' => 'www-proxy.us.oracle.com', 'DproxyPort'=>'80', '-verbose' => '' 
end

omc_elasticsearch_plugin 'kopf' do
  action :uninstall
  es_home node[:omc_elasticsearch][:install_path]
  uri 'lmenezes/elasticsearch-kopf/master'
  #arguments '-DproxyHost=www-proxy.us.oracle.com -DproxyPort=80 --verbose'
  #arguments 'DproxyHost' => 'www-proxy.us.oracle.com', 'DproxyPort'=>'80', '-verbose' => '' 
end
=end
=begin
omc_elasticsearch_config 'elasticsearch' do
#  user 'elasticsearch'
#  group 'elasticsearch'
  cluster_name 'kitchen-cluster01'
  install_path '/usr/share/elasticsearch'
  data_path '/data/kitchen-cluster01/data'
  log_path '/data/kitchen-cluster01/log'
  work_path '/data/kitchen-cluster01/work'
  config_path '/etc/elasticsearch'
  pid_path '/var/run/elasticsearch'
  #http_port 9200
  #transport_port 9300
  node_name node['fqdn'].downcase
  bind_ip '0.0.0.0'
  publish_ip '0.0.0.0'
  action :render
  elasticsearch_data_bag_info 'slapchop' => 'elasticsearch_localdev'
  #java_opts node[:omc_slapchop][:elasticsearch][:java_opts]
  override_java_opts  '-Xmx' => '768m'
  #default_config node[:omc_slapchop][:elasticsearch][:default_config]
  override_config {}
  #default_sysconfig node[:omc_slapchop][:elasticsearch][:default_sysconfig]
  override_sysconfig 'ES_RESTART_ON_UPGRADE' => false
end
=end
