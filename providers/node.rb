use_inline_resources

def whyrun_supported?
   true
end

action :install do
  version = new_resource.version

  group new_resource.group do
    action :create
    system true
  end

  user new_resource.user do
    home  new_resource.home
    shell  new_resource.shell
    gid  new_resource.group
    supports manage_home: false
    action  :create
    system true
  end

  [ new_resource.home,new_resource.data_path,new_resource.log_path,new_resource.config_path, new_resource.work_path, new_resource.pid_path ].each do |dir|
    create_directory(dir, new_resource.user, new_resource.group)
  end

  version_major_minor = version.match(/^[0-9]\.[0-9]*/)
  yum_repository "elasticsearch-#{version_major_minor}" do
    description "Elasticsearch repository for #{version_major_minor}.x packages"
    baseurl new_resource.base_url
    gpgkey new_resource.gpgkey_url
    action :create
  end

  yum_package 'elasticsearch' do
    version version
    action :install
  end
end

def create_directory(path,es_owner,es_group)
  directory path do
    owner es_owner
    group es_group
    mode '0755'
    recursive true
    action :create
  end
end

=begin
action :configure do
  service 'elasticsearch' do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action :nothing
  end

  template "Init.d script for elasticsearch do
    path '/etc/init.d/elasticsearch'
    source 'etc/initd/elasticsearch.erb'
    owner new_resource.user
    group new_resource.group
    mode '0755'
    cookbook 'omc_elasticsearch'
    notifies :enable, "service[#{new_resource.service_name}]"
    notifies :start, "service[#{new_resource.service_name}]"
    variables( :install_dir => new_resource.install_path, :data_dir => new_resource.data_path, :log_dir => new_resource.log_path, :config_dir => new_resource.config_path)
  end
end
=end

def load_current_resource
  @current_resource = Chef::Resource::OmcElasticsearchNode.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.shell(@new_resource.shell)
  @current_resource.home(@new_resource.home)
  @current_resource.version(@new_resource.version)
  @current_resource.base_url(@new_resource.base_url)
  @current_resource.gpgkey_url(@new_resource.gpgkey_url)
  @current_resource.install_path(@new_resource.install_path)
  @current_resource.cluster_name(@new_resource.cluster_name)
  @current_resource.data_path(@new_resource.data_path)
  @current_resource.log_path(@new_resource.log_path)
  @current_resource.config_path(@new_resource.config_path)
  @current_resource.work_path(@new_resource.work_path)
  @current_resource.pid_path(@new_resource.pid_path)
end
