actions :install
default_action :install

# User
attribute :user, :kind_of => String, default: 'elasticsearch'
attribute :group, :kind_of => String, default: 'elasticsearch'
attribute :shell, kind_of: String, default: '/bin/bash'
attribute :home, :kind_of => String, default: '/scratch/elasticsearch_home'

# RPM
attribute :version, kind_of: String, required: true
attribute :base_url, kind_of: String, default: 'http://packages.elasticsearch.org/elasticsearch/1.7/centos'
attribute :gpgkey_url, kind_of: String, default: 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'

attribute :install_path, :kind_of => String, default: '/usr/share/elasticsearch'
# ES Config
attribute :cluster_name, :kind_of => String, default: 'omc-eventstore-localdev'
attribute :config_path, :kind_of => String, default: '/etc/elasticsearch'
attribute :data_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'data') }
attribute :log_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'log') }
attribute :work_path, :kind_of => String, default: lazy { |r| ::File.join('/scratch', r.cluster_name, 'work') }
attribute :pid_path, :kind_of => String, default: "/var/run/elasticsearch"
