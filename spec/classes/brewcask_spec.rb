require 'spec_helper'

describe 'brewcask' do
  let(:facts) { default_test_facts }

  it do
    should contain_class('boxen::config')
    should contain_class('homebrew')

  end
end
