# frozen_string_literal: true

control 'fail2ban.package.install' do
  title 'The required package should be installed'

  package_name = 'fail2ban'

  describe package(package_name) do
    it { should be_installed }
  end
end
