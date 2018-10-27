module ProspectusTerraform
  ##
  # Lookup object to find providers
  class Lookup
    PROVIDER_REGEX = /provider\.(?<key>[\w-]+) (?<value>[\d.]+)$/.freeze
    REPO_REGEX = %r{^  // provider\.(?<key>[\w-]+) (?<value>[\w-]+\/[\w-]+)}.freeze # rubocop:disable Metrics/LineLength

    def results
      @results ||= providers.map do |name, version|
        [name, version, repos[name] || default_repo(name)]
      end
    end

    def providers
      @providers ||= match_to_hash(provider_lines, PROVIDER_REGEX)
    end

    def provider_lines
      @provider_lines ||= `terraform providers`.lines
    end

    def repos
      @repos ||= match_to_hash(repo_lines, REPO_REGEX)
    end

    def repo_lines
      @repo_lines ||= File.read('main.tf').lines
    end

    def match_to_hash(lines, regex)
      lines.map { |x| x.match(regex) }.compact.map { |x| [x[1], x[2]] }.to_h
    end

    def default_repo(name)
      "terraform-providers/terraform-provider-#{name}"
    end
  end

  ##
  # Helper for automatically adding provider status check
  class Providers < Module
    def extended(other) # rubocop:disable Metrics/MethodLength
      lookup = Lookup.new

      other.deps do
        lookup.results.each do |provider_name, provider_version, provider_repo|
          item do
            name "provider-#{provider_name}"

            expected do
              github_tag
              repo provider_repo
              regex(/^v?([\d.]+)$/)
            end

            actual do
              static
              set provider_version
            end
          end
        end
      end
    end
  end
end
