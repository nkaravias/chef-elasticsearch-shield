actions(:install,:uninstall,:configure)
default_action(:install)

# User
attribute :user, :kind_of => String, default: 'elasticsearch'
attribute :group, :kind_of => String, default: 'elasticsearch'
attribute :es_home, :kind_of => String, default: '/usr/share/elasticsearch'
attribute :config_path, :kind_of => String, default: "/etc/elasticsearch"
attribute :uri, :kind_of => String, required: true
attribute(:arguments, kind_of: Hash, default: {})
attribute(:configuration_opts, kind_of: Hash, default: {})
attribute :plugin_data, :kind_of => Array, default: []
