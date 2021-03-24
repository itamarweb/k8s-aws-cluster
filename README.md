# k8s-aws-cluster
 simple AWS kubernetes cluster









# 1. Lunch Instances and configure security settings

 - Use AWS EC2 consol to lunch 3 instances with ubuntu 20.2 LTS image.
 - Make sure you have a lest 2 vCPUs and 4Gb of RAM. A good machin will be t2.medium
 - Connect them all to same security group. Later you can divide the security group to Nodes and Master.
 - Keep the default port 22 open for SSH. feel free to change it to your specific ip address.


## ports to open
make sure these port ar open at the security group settings:

 | Protocol | Direction|	Port Range |	Purpose	|
 | ------------- | -------------|	------------- |	-------------	|
 | TCP |	Inbound |	6443 |	Kubernetes API server |
 | TCP	| Inbound |	2379-2380 |	etcd server client API |
 | TCP |	Inbound |	10250	| kubelet API |
 | TCP |	Inbound |	10251 |	kube-scheduler |
 | TCP |	Inbound |	10252 |	kube-controller-manager |
 | TCP |	Inbound |	30000 - 32767 |	NodePort Services |
 
 
 # 2. Set up environments:
 
 ## On master node:
 
 open terminal on the master node (or log in via SSH).
 
 ### Hot-linkcommand:
 ```
 sudo bash <(curl -s https://www.dropbox.com/s/c3nd9au2x8yestq/master-node-setup.sh?dl=1)
 ```
 *if you don't want to use a hot-link you can download the "master-node-setup.sh" from the repository and run it from local path
 
 
 
 
 
 
 
