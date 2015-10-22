require 'spec_helper'

describe_recipe 'monit::default' do

  context 'with all default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
