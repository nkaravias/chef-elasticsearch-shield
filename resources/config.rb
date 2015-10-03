actions(:render)
default_action(:render)

# User
attribute :user, :kind_of => String, default: 'elasticsearch'
attribute :group, :kind_of => String, default: 'elasticsearch'
#
attribute :install_path, :kind_of => String, default: '/usr/share/elasticsearch'
# # ES Config
attribute :cluster_name, :kind_of => String, default: 'omc-eventstore-localdev'
attribute :work_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'work') }
attribute :data_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'data') }
attribute :log_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'log') }
attribute :config_path, :kind_of => String, default: "/etc/elasticsearch"
attribute :pid_path, :kind_of => String, default: "/var/run/elasticsearch"

attribute :http_port, :kind_of => Integer, default: 9200
attribute :transport_port, :kind_of => Integer, default: 9300

attribute :node_name, :kind_of => String, default: lazy { node.hostname }
attribute :ip, :kind_of => String, default: lazy { node[:ipaddress] }
#attribute :node_list, :kind_of => Array, required: true

attribute(:elasticsearch_data_bag_info, kind_of: Hash,   required: true)

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

attribute(:override_java_opts, kind_of: Hash, default: {})

### Sysconfig attributes for ES
# Default
attribute(:default_sysconfig, kind_of: Hash, default: {
#'ES_HEAP_NEWSIZE' => '',
#'ES_DIRECT_SIZE' => '',
'ES_RESTART_ON_UPGRADE' => true,
'ES_GC_LOG_FILE'=> '/var/log/elasticsearch/gc.log',
'MAX_OPEN_FILES' => '65535',
'MAX_MAP_COUNT' => '262144'
})
# Override
attribute(:override_sysconfig, kind_of: Hash, default: {})

### General configuration attributes for ES
# Default
attribute(:default_config, kind_of: Hash, default: {
  'action.destructive_requires_name' => true,
  'node.max_local_storage_nodes' => 1,
  'network.host' => '',
  'discovery.zen.ping.multicast.enabled' => false,
  'discovery.zen.ping.unicast.hosts' => '[]',
  'discovery.zen.minimum_master_nodes' => 1,
  'gateway.expected_nodes' => 1,
})
# Override
attribute(:override_config, kind_of: Hash, default: {})
