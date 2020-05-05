require_relative('../../lib/symbol_utilities')
require 'byebug' 
describe SymbolUtilities::Influxdb do
  before(:all) do
    config_input_dir  = '/config-data'
    config_input = SymbolUtilities::ConfigInput.new(config_input_dir)
    @test_db_name = 'test_db' # TODO: make this randomly generated and then delete this in :after all
    @client = SymbolUtilities::Influxdb::Client.new(@test_db_name, host: config_input.influxdb_host)
  end
  
  context 'Client' do
    before(:all) do
      @show_databases_response = @client.query('SHOW DATABASES') 
    end
    it { expect(@show_databases_response).to be_an(::Array) }
    it { expect(@show_databases_response.size).to eq(1) }
    
    subject(:database_list) { @show_databases_response.first['values'].map { |hash| hash['name'] } }
    it { expect(database_list).to include(@test_db_name) }

  end
  
  context 'Measurement' do
    before(:all) do
      @measurement_name = 'test_measurement'
      @measurement = @client.measurement(@measurement_name)
      @value_hash = { value1: 1, value2: 2 }
      @tag_hash   = { tag1: 'tag1', tag2: 'tag2' } 
      @measurement.write_point(@value_hash, @tag_hash)
    end
    
    # TODO: write expects
    it { pp @measurement.get_last_point(@tag_hash) }
    
  end
  
end

