require 'open3'
require 'open-uri'

module ProspectusTerraform
  ##
  # Module object, for passing state and update info
  class ModuleData
    attr_reader :name, :version

    def initialize(params)
      @name = params['source']
      @version = params['version']
    end

    def latest
      resp = JSON.parse(open(latest_url).read) # rubocop:disable Security/Open
      resp['version']
    end

    private

    def latest_url
      @latest_url ||= 'https://registry.terraform.io/v1/modules/' + name
    end
  end

  ##
  # Helper for automatically adding module status check
  class Modules < Module
    def extended(other) # rubocop:disable Metrics/MethodLength
      modules_object = modules

      other.deps do
        modules_object.each do |m|
          item do
            name "module-#{m.name}"

            expected do
              static
              set m.latest
            end

            actual do
              static
              set m.version
            end
          end
        end
      end
    end

    def config_json
      return @config_json if @config_json
      stdout, stderr, status = Open3.capture3(cmd_name)
      raise("#{cmd_name} failed") unless status.success? && stderr.empty?
      @config_json = stdout
    end

    def cmd_name
      'terraform-config-inspect --json'
    end

    def modules
      @modules ||= JSON.parse(config_json)['module_calls'].values.map do |x|
        ModuleData.new(x)
      end
    end
  end
end
