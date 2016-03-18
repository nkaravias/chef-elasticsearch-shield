actions(:install,:uninstall)
default_action(:install)

# User
attribute :user, :kind_of => String, default: 'elasticsearch'
attribute :group, :kind_of => String, default: 'elasticsearch'
attribute :es_home, :kind_of => String, default: '/usr/share/elasticsearch'
attribute :uri, :kind_of => String, required: true
attribute(:arguments, kind_of: Hash, default: {})
