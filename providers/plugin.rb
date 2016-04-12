include Elasticsearch::EsHelper

action :install do
  args = new_resource.arguments.map{|k,v|  v == '' ? "-#{k}" : "-#{k}=#{v}"}.join(' ')
  execute "Install #{new_resource.name}" do
    cwd new_resource.es_home
    command "./bin/plugin install #{new_resource.uri} #{args}"
    user new_resource.user
    group new_resource.user
#    creates ::File.join(new_resource.es_home,'plugins',new_resource.name)
    not_if { plugin_installed?(new_resource.name, new_resource.es_home) }
  end
  # state has changed - notify 
  #new_resource.updated_by_last_action(true)
end

action :uninstall do
  execute "Uninstall #{new_resource.name}" do
    cwd new_resource.es_home
    command "./bin/plugin remove #{new_resource.name}"
    user new_resource.user
    group new_resource.user
  only_if { plugin_installed?(new_resource.name, new_resource.es_home) }
  # state has changed - notify 
  # new_resource.updated_by_last_action(true)
  end
end

action :configure do
  config_opts = new_resource.configuration_opts
  if config_opts.empty? 
    puts "plugin #{new_resource.name} has no attribute set for configuration_opts"
  else
    puts "plugin #{new_resource.name} has these options: #{config_opts}"
  end

  case new_resource.name
  when 'shield' 

    mappings= config_opts[:role_mapping][:mappings]
    template "shield role_mapping configuration" do
      path ::File.join(new_resource.config_path, 'shield', 'role_mapping.yml')
      source 'plugins/shield/role_mapping.yml.erb'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      #helpers(Elasticsearch::EsHelper)
      cookbook 'omc_elasticsearch'
      variables(:role_mappings => mappings)
    end

    template "shield roles configuration" do
      path ::File.join(new_resource.config_path, 'shield', 'roles.yml')
      source 'plugins/shield/roles.yml.erb'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      cookbook 'omc_elasticsearch'
    end

    template "shield logging configuration" do
      path ::File.join(new_resource.config_path, 'shield', 'logging.yml')
      source 'plugins/shield/logging.yml.erb'
      owner new_resource.user
      group new_resource.group
      mode '0644'
      cookbook 'omc_elasticsearch'
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::OmcElasticsearchPlugin.new(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(@new_resource.group)
  @current_resource.es_home(@new_resource.es_home)
  @current_resource.uri(@new_resource.uri)
  @current_resource.arguments(@new_resource.arguments)
  @current_resource.configuration_opts(@new_resource.configuration_opts)
end
