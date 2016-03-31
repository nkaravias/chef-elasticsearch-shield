include Elasticsearch::EsHelper

action :render do
  service 'elasticsearch' do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action :nothing
  end
   
  default_sysconfig= new_resource.default_sysconfig.merge(new_resource.override_sysconfig)
  default_sysconfig['CONF_DIR']=new_resource.config_path
  default_sysconfig['DATA_DIR']=new_resource.data_path
  default_sysconfig['LOG_DIR']=new_resource.log_path
  default_sysconfig['WORK_DIR']=new_resource.work_path
  default_sysconfig['PID_DIR']=new_resource.pid_path
  default_sysconfig['ES_HOME']=new_resource.install_path
  default_sysconfig['ES_USER']=new_resource.user
  default_sysconfig['ES_GROUP']=new_resource.group
  default_java_opts = new_resource.java_opts
  default_sysconfig['ES_JAVA_OPTS']= default_java_opts.merge(new_resource.override_java_opts)
  # ES_HEAP_SIZE is set from ES_JAVA_OPTS['-Xmx']
  # If [-Xmx] has been overriden and is nil - raise an exception
  if default_sysconfig['ES_JAVA_OPTS'].has_key?('-Xmx')
    default_sysconfig['ES_HEAP_SIZE']=default_sysconfig['ES_JAVA_OPTS']['-Xmx']
    puts "Setting $ES_HEAP_SIZE equal to $ES_JAVA_OPTS['-Xmx'] (#{default_sysconfig['ES_JAVA_OPTS']['-Xmx']})"
  else
    raise "The -Xmx key is not set. Check the default_sysconfig & override_sysconfig attributes"
  end 

  template "Elasticsearch sysconfig parameters" do
    path '/etc/sysconfig/elasticsearch'
    source 'sysconfig/elasticsearch.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
    cookbook 'omc_elasticsearch'
    helpers(Elasticsearch::EsHelper)
    variables(:config => default_sysconfig)
    notifies :enable,"service[elasticsearch]"
    notifies :restart,"service[elasticsearch]"
  end

  template "Elasticsearch.in.sh configuration" do
    path ::File.join(new_resource.install_path,'bin','elasticsearch.in.sh')
    source 'etc/elasticsearch.in.sh.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
    cookbook 'omc_elasticsearch'
    helpers(Elasticsearch::EsHelper)
    variables(:es_home => default_sysconfig['ES_HOME'], :es_java_opts => default_sysconfig['ES_JAVA_OPTS'], :es_version => new_resource.version)
    notifies :enable,"service[elasticsearch]"
    notifies :restart,"service[elasticsearch]"
  end

  default_config = new_resource.default_config.merge(new_resource.override_config)
  # Add global attributes
  default_config['cluster.name']=new_resource.cluster_name
  default_config['node.name']=new_resource.node_name
  default_config['network.bind_host']=new_resource.bind_ip
  default_config['network.publish_host']=new_resource.publish_ip
  default_config['path.conf']=new_resource.config_path
  default_config['path.data']=new_resource.data_path
  default_config['path.log']=new_resource.log_path
  
  default_config['http.port']=new_resource.http_port
  default_config['transport.tcp.port']=new_resource.transport_port

  # Generate cluster host list from the data bag input
  es_dbag_key = new_resource.elasticsearch_data_bag_info.keys.first
  default_config['discovery.zen.ping.unicast.hosts'] = get_active_host_hash(data_bag_item(es_dbag_key, new_resource.elasticsearch_data_bag_info[es_dbag_key]))

  template "Elasticsearch config" do
    path ::File.join(new_resource.config_path,'elasticsearch.yml')
    source 'etc/elasticsearch.yml.erb'
    owner new_resource.user
    group new_resource.group
    mode '0644'
    helpers(Elasticsearch::EsHelper)
    cookbook 'omc_elasticsearch'
    variables(:config => default_config)
    notifies :enable,"service[elasticsearch]"
    notifies :restart,"service[elasticsearch]"
  end

  template "Init.d script for elasticsearch" do
    path '/etc/init.d/elasticsearch'
    source 'etc/initd/elasticsearch.erb'
    owner new_resource.user
    group new_resource.group
    mode '0755'
    cookbook 'omc_elasticsearch'
    notifies :enable,"service[elasticsearch]"
    notifies :restart,"service[elasticsearch]"
  end

  # state has changed - notify 
  #new_resource.updated_by_last_action(true)
end

def load_current_resource
  @current_resource = Chef::Resource::OmcElasticsearchConfig.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.install_path(@new_resource.install_path)
  @current_resource.cluster_name(@new_resource.cluster_name)
  @current_resource.node_name(@new_resource.node_name)
  @current_resource.bind_ip(@new_resource.bind_ip)
  @current_resource.publish_ip(@new_resource.publish_ip)
  @current_resource.elasticsearch_data_bag_info(@new_resource.elasticsearch_data_bag_info)
  @current_resource.work_path(@new_resource.work_path)
  @current_resource.data_path(@new_resource.data_path)
  @current_resource.log_path(@new_resource.log_path)
  @current_resource.config_path(@new_resource.config_path)
  @current_resource.pid_path(@new_resource.pid_path)
  @current_resource.http_port(@new_resource.http_port)
  @current_resource.transport_port(@new_resource.transport_port)
  @current_resource.java_opts(@new_resource.java_opts)
  @current_resource.override_java_opts(@new_resource.override_java_opts)
  @current_resource.default_config(@new_resource.default_config)
  @current_resource.override_sysconfig(@new_resource.override_sysconfig)
  @current_resource.default_sysconfig(@new_resource.default_sysconfig)
  @current_resource.override_config(@new_resource.override_config)
end
