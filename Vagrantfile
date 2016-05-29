# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

PUPPET_UPGRADE = <<EOF
if [[ $(/usr/bin/env puppet --version) != *4.4.2* ]]; then
  wget --quiet -P /tmp http://apt.puppetlabs.com/puppetlabs-release-pc1-precise.deb
  aptitude remove --purge -y "puppet*"
  dpkg -i /tmp/puppetlabs-release-pc1-precise.deb
  aptitude update > /dev/null
  aptitude install -y puppet-agent python-software-properties
#  sed -i '/templatedir/d' /etc/puppet/puppet.conf
#  cp /etc/hiera.yaml /etc/puppet/hiera.yaml
 fi
EOF

HACKEN_BOOTSTRAP = <<EOF
  cd /opt/hacken.in
  bundle install --path=vagrant/vendor
  bundle exec rake db:migrate
EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.network :private_network, ip: "192.168.33.100"
  config.vm.hostname = 'hacken'

  config.vm.synced_folder ".", "/opt/hacken.in", type: 'nfs'
  # rsync fallback if NFS has issues with encrypted filesystems
  # local code changes need to be re-synced to the VM via `vagrant reload --provision`
  #config.vm.synced_folder ".", "/opt/hacken.in", type: 'rsync', rsync__args: ['-a']

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
  end

  config.vm.provision "shell", inline: PUPPET_UPGRADE

  config.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true
  config.vm.network "forwarded_port", guest: 5432, host: 5432, auto_correct: true

  config.vm.provision :puppet do |puppet|
    puppet.environment = 'development'
    puppet.environment_path = 'vagrant/puppet/environments'
    puppet.module_path = 'vagrant/puppet/modules'

    puppet.facter = {
      'hackenin_application_environment' => 'development',
      'hackenin_ruby_version'            => "ruby2.2" # ¯\_ಠ_ಠ_/¯
    }
  end

 config.vm.provision "shell", privileged: false, inline: HACKEN_BOOTSTRAP
end
