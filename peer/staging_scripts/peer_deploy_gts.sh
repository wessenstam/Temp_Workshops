#!/usr/bin/env bash

# PAY ATTENTION TO NETWORK AND IMAGE NAMES BELOW!!!

###############################################################################################################################################################################
# Routine to set the acli command
###############################################################################################################################################################################
function acli() {
  local _cmd

  _cmd=$*
	/usr/local/nutanix/bin/acli ${_cmd}
  # DEBUG=1 && if [[ ${DEBUG} ]]; then log "$@"; fi
}

###############################################################################################################################################################################
# Routine to deploy the Peer Management Center
###############################################################################################################################################################################
# MTM TODO When integrating with Nutanix scripts, need to change echo to log and put quotes around text after all acli commands
deploy_peer_mgmt_server() {

  VMNAME=$1

  echo "${VMNAME} - Prepping image..."

  # MTM TODO Get image locally OR download from Azure Blob storage
  IMAGENAME="Windows2016-PeerMgmt-18feb20.qcow2"

  ### Get sysyprep config file ready ###

  echo "${VMNAME} - Prepping sysprep config..."
  # MTM Create a temp folder for sysprep file work as to not clutter up nutanix home
  #mkdir /home/nutanix/peer_staging/

  #MTM todo have unattend-pmc.xml staged somewhere else
  wget https://peerresources.blob.core.windows.net/ntnx-gts-2020-images/peer_lab/unattend-pmc.xml -P /home/nutanix/peer_staging/
  mv /home/nutanix/peer_staging/unattend-pmc.xml /home/nutanix/peer_staging/unattend_${VMNAME}.xml
  chmod 777 /home/nutanix/peer_staging/unattend_${VMNAME}.xml
  sed -i "s/<ComputerName>.*<\/ComputerName>/<ComputerName>${VMNAME}<\/ComputerName>/g" /home/nutanix/peer_staging/unattend_${VMNAME}.xml

  ### Deploy PMC Server ###
  
  echo "${VMNAME} - Deploying VM..."
  #log "Create ${VMNAME} VM based on ${IMAGENAME} image"
  acli "uhura.vm.create_with_customize ${VMNAME} num_vcpus=2 num_cores_per_vcpu=2 memory=4G sysprep_config_path=file:///home/nutanix/peer_staging/unattend_${VMNAME}.xml"
  acli "vm.disk_create ${VMNAME} clone_from_image=${IMAGENAME}"
  # MTM TODO replace net1 with appropriate variable
  acli "vm.nic_create ${VMNAME} network=Secondary"

  #log "Power on ${VMNAME} VM..."
  echo "${VMNAME} - Powering on..."
  acli "vm.on ${VMNAME}"

  echo "${VMNAME} - Deployed."

}

###############################################################################################################################################################################
# Routine to deploy a Peer Agent
###############################################################################################################################################################################
# MTM TODO When integrating with Nutanix scripts, need to change echo to log and put quotes around text after all acli commands
deploy_peer_agent_server() {

  VMNAME=$1

  echo "${VMNAME} - Prepping image..."

  # MTM TODO Get image locally OR download from Azure Blob storage
  IMAGENAME="Windows2016-PeerAgent-18feb20.qcow2"

  ### Get sysyprep config file ready ###

  echo "${VMNAME} - Prepping sysprep config..."
  # MTM Create a temp folder for sysprep file work as to not clutter up nutanix home
  #mkdir /home/nutanix/peer_staging/

  #MTM todo have unattend-agent.xml staged somewhere else
  wget https://peerresources.blob.core.windows.net/ntnx-gts-2020-images/peer_lab/unattend-agent.xml -P /home/nutanix/peer_staging/
  mv /home/nutanix/peer_staging/unattend-agent.xml /home/nutanix/peer_staging/unattend_${VMNAME}.xml
  chmod 777 /home/nutanix/peer_staging/unattend_${VMNAME}.xml
  sed -i "s/<ComputerName>.*<\/ComputerName>/<ComputerName>${VMNAME}<\/ComputerName>/g" /home/nutanix/peer_staging/unattend_${VMNAME}.xml

  ### Deploy Agent Server ###
  
  echo "${VMNAME} - Deploying VM..."
  #log "Create ${VMNAME} VM based on ${IMAGENAME} image"
  acli "uhura.vm.create_with_customize ${VMNAME} num_vcpus=2 num_cores_per_vcpu=2 memory=4G sysprep_config_path=file:///home/nutanix/peer_staging/unattend_${VMNAME}.xml"
  acli "vm.disk_create ${VMNAME} clone_from_image=${IMAGENAME}"
  # MTM TODO replace net1 with appropriate variable
  acli "vm.nic_create ${VMNAME} network=Secondary"

  #log "Power on ${VMNAME} VM..."
  echo "${VMNAME} - Powering on..."
  acli "vm.on ${VMNAME}"

  echo "${VMNAME} - Deployed."

}

echo "Creating temp folder and applying perms..."
mkdir /home/nutanix/peer_staging/
#chown nutanix:nutanix /home/nutanix/peer_staging/
#chown 755 /home/nutanix/peer_staging/

#download_necessary_images_from_azure

PMC="PeerMgmt"
deploy_peer_mgmt_server ${PMC}
AGENTA="PeerAgent-Files"
deploy_peer_agent_server ${AGENTA}
AGENTB="PeerAgent-Win"
deploy_peer_agent_server ${AGENTB}
  
echo "Waiting 60 seconds, then cleaning up..."

sleep 60

rm -rf /home/nutanix/peer_staging/
