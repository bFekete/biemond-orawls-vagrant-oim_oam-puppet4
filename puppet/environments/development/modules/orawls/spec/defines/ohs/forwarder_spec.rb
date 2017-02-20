require 'spec_helper'

describe 'orawls::ohs::forwarder', :type => :define do
  let(:title) {'/console'}

  describe 'call with param servers empty should fail' do
    let(:params) {{:os_user     => 'oracle',
                   :os_group    => 'oracle',
                   :domain_dir  => '/opt/test/wls/domains/domain1'
    }}

    it {
      should raise_error(Puppet::Error, /parameter 'servers' expects an Array value, got Undef/)
    }
  end

  describe 'with one host, console port' do
    let(:params) {{:os_user     => 'oracle',
                   :os_group    => 'oracle',
                   :servers     => ['192.168.1.1:7001'],
                   :domain_dir  => '/opt/test/wls/domains/domain1'
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/console.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7001/)
    }
  end

  describe 'with one host, custom port' do
    let(:params) {{:os_user    => 'oracle',
                   :os_group   => 'oracle',
                   :servers    => ['192.168.1.1:7002'],
                   :domain_dir => '/opt/test/wls/domains/domain1'
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/console.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicHost 192.168.1.1/)
      .with_content(/WebLogicPort 7002/)
    }
  end

  describe 'with two hosts without console ports' do
    let(:params) {{:os_user    => 'oracle',
                   :os_group   => 'oracle',
                   :servers    => ['192.168.1.1', '192.168.1.2'],
                   :domain_dir => '/opt/test/wls/domains/domain1'
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/console.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1,192.168.1.2/)
    }
  end

  describe 'with two hosts, one with custom port' do
    let(:params) {{:os_user     => 'oracle',
                   :os_group    => 'oracle',
                   :servers     => ['192.168.1.1:7003', '192.168.1.2'],
                   :domain_dir  => '/opt/test/wls/domains/domain1'
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/console.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1:7003,192.168.1.2/)
    }
  end

  describe 'with two hosts, both with custom ports' do
    let(:params) {{:os_user     => 'oracle',
                   :os_group    => 'oracle',
                   :servers     => ['192.168.1.1:7003', '192.168.1.2:7004'],
                   :domain_dir  => '/opt/test/wls/domains/domain1'
    }}

    it {
      should contain_file('/opt/test/wls/domains/domain1/config/fmwconfig/components/OHS/ohs1/mod_wl_ohs.d/console.conf').with({
        'ensure'  => 'present',
        'owner'   => 'oracle',
        'group'   => 'oracle',
      })
      .with_content(/\<LocationMatch "\/console"\>/)
      .with_content(/WebLogicCluster 192.168.1.1:7003,192.168.1.2:7004/)
    }
  end
end