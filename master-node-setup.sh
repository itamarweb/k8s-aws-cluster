#!/bin/bash



# ------------------------------------ Docker installation --------------------------------------------
sudo apt-get update

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

printf "\n\n\n ----------- \n\n\n Docker installation finished! \n\n\n ----------- \n\n\n"

# ------------------------------------ END: Docker installation --------------------------------------------



# ------------------------------------     K8S installation     --------------------------------------------
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# ------------------------------------  END: K8S installation   --------------------------------------------


#Networking setup
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

#Initialize the cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#set up a Kubernetes configuration file for general usage
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#apply a common networking plugin - Flannel
kubectl apply -f  https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml



#finish notice
JOINCOMMAND=$(sudo kubeadm token create --print-join-command)
printf "\n\n\n ----------- \n\n\nSetup finised successfully!\n\nPlease copy the join command to a secure location: \n\n************** \n\n$JOINCOMMAND\n\n**************\n\n\n----------- \n\n\n"
