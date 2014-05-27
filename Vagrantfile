# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

PUPPET_UPGRADE = <<EOF
if [[ $(/usr/bin/puppet --version) != *3.4.3* ]]; then
  wget --quiet -P /tmp http://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i /tmp/puppetlabs-release-precise.deb
  aptitude update > /dev/null
  aptitude install -y puppet=3.4.3
fi
EOF

HACKEN_BOOTSTRAP = <<EOF
  cd /opt/hacken.in
  bundle
  bundle exec rake db:migrate
EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.network :private_network, ip: "192.168.33.100"
  config.vm.hostname = 'hacken'

  config.vm.synced_folder ".", "/opt/hacken.in", type: 'nfs'

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "shell", inline: PUPPET_UPGRADE

  config.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true
  config.vm.network "forwarded_port", guest: 5432, host: 5432, auto_correct: true

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'puppet/modules'
    puppet.manifests_path = 'puppet/manifests'
		puppet.facter = {
      'hackenin_application_environment' => 'development',
      'hackenin_ruby_version'            => File.read('.ruby-version').strip
    }
  end

  config.vm.provision "shell", privileged: false, inline: HACKEN_BOOTSTRAP
end
