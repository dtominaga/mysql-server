#!/bin/bash

echo "resource_copy::start"

VAGRANT_HOME_DIR="/home/vagrant"
CHEF_REPO="chef-repo"
CHEF_REPO_DIR=${VAGRANT_HOME_DIR}/${CHEF_REPO}
RESOURCE_DIR="/vagrant/resource"

sudo rm -rf ${VAGRANT_HOME_DIR}/file* ${VAGRANT_HOME_DIR}/sh-thd-*
sudo rm -rf ${RESOURCE_DIR}/file* ${RESOURCE_DIR}/sh-thd-*

#if [ -e ${RESOURCE_DIR}/config ]; then
#	
#	cp -fpr ${RESOURCE_DIR}/config/* ${CHEF_REPO_DIR}/config/
#	echo "copy config!"
#	
#fi

if [ -e ${RESOURCE_DIR}/cookbooks ]; then
	
	cp -fpr ${RESOURCE_DIR}/cookbooks/* ${CHEF_REPO_DIR}/cookbooks/
	echo "copy cookbooks!"
	
fi

if [ -e ${RESOURCE_DIR}/data_bags ]; then
	
	cp -fpr ${RESOURCE_DIR}/data_bags/* ${CHEF_REPO_DIR}/data_bags/
	echo "copy data_bags!"
	
fi

if [ -e ${RESOURCE_DIR}/environments ]; then
	
	cp -fpr ${RESOURCE_DIR}/environments/* ${CHEF_REPO_DIR}/environments/
	echo "copy environments!"
	
fi

if [ -e ${RESOURCE_DIR}/roles ]; then
	
	cp -fpr ${RESOURCE_DIR}/roles/* ${CHEF_REPO_DIR}/roles/
	echo "copy roles!"
	
fi

if [ -e ${RESOURCE_DIR}/site-cookbooks ]; then

	if [ ! -e ${CHEF_REPO_DIR}/site-cookbooks ]; then
		mkdir ${CHEF_REPO_DIR}/site-cookbooks
	fi
	
	cp -fpr ${RESOURCE_DIR}/site-cookbooks/* ${CHEF_REPO_DIR}/site-cookbooks/
	echo "copy site-cookbooks!"
	
fi

if [ -e ${RESOURCE_DIR}/data_bags ]; then
	
	cp -fpr ${RESOURCE_DIR}/data_bags/* ${CHEF_REPO_DIR}/data_bags/
	echo "copy data_bags!"
	
fi

cp -fpr ${RESOURCE_DIR}/chef_*.sh ${CHEF_REPO_DIR}/
echo "copy shells!"

echo "resource_copy::end"
exit 0
