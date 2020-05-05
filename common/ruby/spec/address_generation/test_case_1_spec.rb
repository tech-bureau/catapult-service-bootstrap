require_relative('../../lib/symbol_utilities')
require 'byebug' 
describe SymbolUtilities::Tools::Address do
  before(:all) do
    address_helper       = SymbolUtilities::Tools::Address.new
    @generated_addresses = address_helper.generate_addresses(3)
    @private_address     = address_helper.generate_address(:private)
  end
  it { pp @generated_addresses }
  it { expect(@generated_addresses).to be_a(::Array) }
  it { expect(@generated_addresses.size).to eq(3) }
  it { expect(@generated_addresses.first).to be_a(SymbolUtilities::Parse::Addresses::Element) }

  it { pp @private_address }
  # TODO: make sure that private address has correct form
end
