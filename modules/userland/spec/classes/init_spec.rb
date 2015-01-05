require 'spec_helper'
describe 'userland' do

  context 'with defaults for all parameters' do
    it { should contain_class('userland') }
  end
end
