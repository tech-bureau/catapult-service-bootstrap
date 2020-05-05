require_relative('../../lib/symbol_utilities')
require 'byebug' 
describe SymbolUtilities::Tools::Health do
  context 'Get and parse' do
    before(:all) do
      @parsed_health_info = SymbolUtilities::Tools::Health.get_health_info
    end
    # TODO: write expects
    it { pp @parsed_health_info }
  end

  context 'Parsing' do
    before(:all) do
      raw_health_info_path = ::File.expand_path('../resources/raw_health_info', ::File.dirname(__FILE__))
      @raw_health_info = ::File.read(raw_health_info_path) 
      @grok = SymbolUtilities::Parse::Grok.new
      @grok.add_pattern!('SYMBOL_VALUE', "[0-9']+")
      @grok.add_pattern!('ACNTST_C', 'ACNTST C : %{SYMBOL_VALUE:data}')
      @grok.add_pattern!('ACNTST_C_HVA', 'ACNTST C HVA : %{SYMBOL_VALUE:data}')
    end
    
    # TODO: write expects
    it { pp @grok.match?(@raw_health_info, 'ACNTST_C') }
    it { pp @grok.match?(@raw_health_info, 'ACNTST_C_HVA') }
  end

  context 'get_and_write' do
    before(:all) do
      config_input_dir  = '/config-data'
      config_input = SymbolUtilities::ConfigInput.new(config_input_dir)
      @test_db_name = 'test_db' # TODO: make this randomly generated and then delete this in :after all
      @influxdb_handle = SymbolUtilities::Tools::Health::InfluxdbHandle.new(@test_db_name, config_input)
      SymbolUtilities::Tools::Health.get_and_write_health_info(@influxdb_handle)
    end
    
    # TODO: write expects
    it { pp @influxdb_handle.get_last_point }
  end

end

