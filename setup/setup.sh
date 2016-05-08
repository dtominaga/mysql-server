#!/bin/bash

echo "setup-shell::start"

SSH_HOSTNAME="node-db"
SSH_IP="192.168.53.22"

VAGRANT_HOME_DIR="/home/vagrant"
SETTING_DIR="${VAGRANT_HOME_DIR}/setting"
STATE_DIR="${SETTING_DIR}/state"
SSH_DIR="/etc/ssh/"

CHEF_REPO="chef-repo"

if [ ! -e ${SETTING_DIR} ]; then
	
	# yum update
	sudo yum update -y
	if [ $? -eq 0 ]; then
		
		echo "yum-update::successful"
		
		# ssh setting
		sudo sh -c "echo \"Host ${SSH_HOSTNAME}\" >> ${SSH_DIR}/ssh_config"
		sudo sh -c "  echo \"HostName ${SSH_IP}\" >> ${SSH_DIR}/ssh_config"
		
		sudo chmod 600 ${SSH_DIR}/ssh_config
		
		touch ${VAGRANT_HOME_DIR}/ssh-setting.sh
		echo 'ssh-keygen -t rsa' >> ssh-setting.sh
		echo 'ssh-copy-id node-db' >> ssh-setting.sh
		
		sudo mkdir ${SETTING_DIR}
		sudo mkdir ${STATE_DIR}
		
		echo "initialization::successful"
		
	else
		
		echo "initialization::failure"
		exit 1
		
	fi
	
else
	
	echo "initialization::nothing"
	
fi

if [ ! -e ${STATE_DIR}/chef_install_ok ]; then
	
	# chefdk install
	sudo rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.3.0-1.x86_64.rpm
	if [ $? -eq 0 ]; then
	
		echo "chefdk_install::successful"
		
		# bundle install
		chef gem install bundler
		
		# bundle init
		chef exec bundle init
		
		# gemfile edit
		echo 'gem "chef-zero"' >> ${VAGRANT_HOME_DIR}/Gemfile
		echo 'gem "knife-zero"' >>${VAGRANT_HOME_DIR}/Gemfile
		echo 'gem "knife-helper"' >>${VAGRANT_HOME_DIR}/Gemfile
		
		# gem install
		chef exec bundle install --path vendor/bundle
		if [ $? -eq 0 ]; then
		
			echo "chef-zero_install::successful"
			sudo touch ${STATE_DIR}/chef_install_ok
			echo "chef_install::ok"
		
		else
		
			echo "chef-zero_install::failure"
			exit 1
		
		fi
	
	else
	
		echo "chefdk_install::failure"
		exit 1
	
	fi

else

	echo "chef_install::nothing"

fi

if [ ! -e ${STATE_DIR}/chef_initialization_ok ]; then

	chef generate repo ${CHEF_REPO}
	mkdir ${CHEF_REPO}/.chef
	touch ${CHEF_REPO}/.chef/knife.rb
	echo 'local_mode true' >> ${CHEF_REPO}/.chef/knife.rb
	echo 'chef_repo_dir = File.absolute_path( File.dirname(__FILE__) + "/.." )' >> ${CHEF_REPO}/.chef/knife.rb
	echo 'cookbook_path ["#{chef_repo_dir}/cookbooks", "#{chef_repo_dir}/site-cookbooks"]' >> ${CHEF_REPO}/.chef/knife.rb
	echo 'node_path     "#{chef_repo_dir}/nodes"' >> ${CHEF_REPO}/.chef/knife.rb
	echo 'role_path     "#{chef_repo_dir}/roles"' >> ${CHEF_REPO}/.chef/knife.rb
	echo 'ssl_verify_mode  :verify_peer' >> ${CHEF_REPO}/.chef/knife.rb
	
	#sudo chown vagrant ${CHEF_REPO}/.chef/knife.rb
	
	#sudo touch "${VAGRANT_HOME_DIR}/${CHEF_REPO}/zero-exec.sh"
	#echo 'chef exec bundle exec knife zero chef_client \\\'\"name:$1\"\\\' -x $2 --sudo' >> ${VAGRANT_HOME_DIR}/${CHEF_REPO}/zero-exec.sh
	#echo 'chef exec bundle exec knife zero converge '\''name:$1'\'' --ipaddress $1' >> ${VAGRANT_HOME_DIR}/${CHEF_REPO}/zero-exec.sh
	#sudo touch "${VAGRANT_HOME_DIR}/${CHEF_REPO}/zero-bootstrap.sh"
	#echo 'chef exec bundle exec knife zero bootstrap $1 -x $2 --sudo --node-name $1' >> ${VAGRANT_HOME_DIR}/${CHEF_REPO}/zero-bootstrap.sh
	
	echo "chef_initialization::successful"
	sudo touch ${STATE_DIR}/chef_initialization_ok

else

	echo "chef_initialization::nothing"

fi

echo "setup-shell::end"
exit 0
