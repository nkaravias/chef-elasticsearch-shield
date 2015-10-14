# omc_elasticsearch Cookbook

Installs and configures an elasticsearch cluster node. The cookbook follows the library pattern and exposes two custom resources (LWRP):
* omc_elasticsearch_node
* omc_elasticsearch_config

## Requirements

Third party cookbook dependencies:
* yum (https://supermarket.chef.io/cookbooks/yum)
* java (https://supermarket.chef.io/cookbooks/java)

## Attributes

There are no attributes on a library cookbook. The following resource attributes can get overridden by a wrapper cookbook or an environment / role:

  version [String] package release version
  base_url [String] yum repository url
  gpgkey_url [String] yum repository gpg key url
  cluster_name [String]
  install_path [String]
  data_path [String]
  log_path [String]
  work_path [String]
  config_path [String]
  pid_path [String]
  http_port [Integer] Elasticsearch http api port
  transport_port [Integer] Elasticsearch transport port
  node_name [String] lowercase FQDN
  bind_ip [String]
  publish_ip [String]
  elasticsearch_data_bag_info [Hash] key: data bag with ES host information value: data bag item
  java_opts [Hash] Default jvm values
  override_java_opts [Hash] Override for default jvm values
  default_config [Hash] Default ES configuration values
  override_config [Hash] Override for default ES configuration values
  default_sysconfig [Hash] Default ES sysconfig values
  override_sysconfig [Hash] Override for sysconfig ES values

In regards to various configuration values (sysconfig, java_opts, config) this resource is using generic default values for each use case (e.g default_sysconfig hash). If you simply need to change one of the default values there's two options:
* Override the whole default_sysconfig hash.
* Simply add a new key on the override_sysconfig hash.
This allows for added flexibility when using this custom resource.

Here are the default configuration values for reference:
```ruby
attribute(:java_opts, kind_of: Hash, default: {
'-Xmx' => '512m',
'-Xms' => '512m',
'-Xss' => '256k',
'-Djava.awt.headless='=>true,
'-Djava.net.preferIPv4Stack=' => true,
'-XX:+UseParNewGC' => '',
'-XX:+UseConcMarkSweepGC' => '',
'-XX:CMSInitiatingOccupancyFraction=' => '75',
'-XX:+UseCMSInitiatingOccupancyOnly' => '',
'-XX:+HeapDumpOnOutOfMemoryError' => '',
'-XX:+DisableExplicitGC' => '',
'-Dfile.encoding=' => 'UTF-8'
})

attribute(:default_sysconfig, kind_of: Hash, default: {
'ES_RESTART_ON_UPGRADE' => true,
'ES_GC_LOG_FILE'=> '/var/log/elasticsearch/gc.log',
'MAX_OPEN_FILES' => '65535',
'MAX_MAP_COUNT' => '262144'
})

attribute(:default_config, kind_of: Hash, default: {
  'action.destructive_requires_name' => true,
  'node.max_local_storage_nodes' => 1,
  'discovery.zen.ping.multicast.enabled' => false,
  'discovery.zen.ping.unicast.hosts' => '[]',
  'discovery.zen.minimum_master_nodes' => 1,
  'gateway.expected_nodes' => 1
})
```
## Usage

Check omc_elasticsearch::default for an example use case that creates and configures a single node ES cluster

## Contributing

1. Create a named feature branch (adding any relevant Jira ID as a prefix is the recommended approach).If you do not have access reach out to the OMC Eloqua DevOps team at erd_devops_us_grp@oracle.com
2. Write your change
3. Write tests for your change (Unit / Integration if applicable)
4. Run the tests, ensuring they all pass
5. Submit a Pull Request
