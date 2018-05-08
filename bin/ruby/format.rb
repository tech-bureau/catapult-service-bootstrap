require 'yaml'
input_file_path = ARGV[0]
fail "No file exists at path '#{input_file_path}'" unless File.file?(input_file_path)

module TopLevel
  def self.parse(input_file_path)
    parsed_flat_form = Helper.parse_into_flat_form(input_file_path)
    parsed_form = Helper.break_into_sections(parsed_flat_form)
    yaml_form = YAML.dump(parsed_form)
    STDOUT << yaml_form                                       
  end

end

module Helper
  SECTION_SIZES = {
   peer_nodes: 5,
   api_nodes: 5,
   rest_gateways: 2,
   nemesis_addresses_harvesting: 3
  # nemesis_addresses: * # dyanmically calculated using left over address
  }

  def self.break_into_sections(parsed_flat_form)
    num_nemesis_addresses = parsed_flat_form.size - SECTION_SIZES.values.inject(0, :+)
    unless num_nemesis_addresses > 0
      fail "Not enough addresses"
    end
    parsed_form = {}
    index       = 0
    SECTION_SIZES.each_pair do |component_type, size|
      parsed_form[component_type.to_s] = parsed_flat_form[index..index+size-1]
      index = index+size
    end
    parsed_form['nemesis_addresses'] = parsed_flat_form[index..-1]
    parsed_form
  end

  def self.parse_into_flat_form(input_file_path)
    parsed_form = []
    next_state   = :private # states can be :private, :public, :address
    next_element = {}
    File.open(input_file_path).read.each_line do |line|
      next unless line =~ Regexp.new("#{next_state}")
      Helper.add_to_element!(next_element, next_state, line)
      case next_state
      when :private 
        next_state = :public
      when :public
        next_state = :address
      when :address
        parsed_form << next_element
        next_element = {}
        next_state = :private
      end
    end
    parsed_form
  end

  NETWORK_NAME = 'public' # otehr viable alternatives are (mijin-test; it is what is set when generate addresses
  def self.add_to_element!(element, state, line)
    value = 
      case state
      when :private 
        value(state, line, /private key: ([0-9A-Z]+)/)
      when :public
        value(state, line, /public key: ([0-9A-Z]+)/)
      when :address
        value(state, line, Regexp.new("address \\(#{NETWORK_NAME}\\): ([0-9A-Z]+)"))
      end
    element.merge!(state.to_s => value)
  end

  private
  def self.value(state, line, regexp)
    unless line =~ regexp
      fail "Cannot find #{state} data"
    end
    $1
  end
end

TopLevel.parse(input_file_path)
