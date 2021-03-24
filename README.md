# k8s-aws-cluster
 simple AWS kubernetes cluster


## Basic requirements:
- Basic knowledge in linux (ubuntu) administration
- basic knowledge in AWS console - knowing how to launch instances and configure security groups




# 1. Lunch Instances and configure security settings

 - Use AWS EC2 consol to lunch 3 **new** instances with ubuntu 20.04 LTS image (name them: node1, node2 and master).
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
 *open to the current security group
 
 # 2. Set up environments:
 
 ## On master node:
 
 open terminal on the master node (or log in via SSH).
 
 ### Hot-linkcommand:
 ```
wget -qO - https://www.dropbox.com/s/c3nd9au2x8yestq/master-node-setup.sh?dl=1  |  bash
 ```
 *if you don't want to use a hot-link you can download the "master-node-setup.sh" from the repository and run it from local path
 
 
 Wait until the execution finishes.
 
 If you see this line: "Setup finised successfully!" you're in a good place.
 
 ---------------------------------------------------------
 copy **to a secure location** the line that contains: 
 ```
 kubeadm join 172.31.76.61:6443 --token ******* \
    --discovery-token-ca-cert-hash sha256:**************** 
 ```
 You will need it later to join a worker node to the cluster.
 
  ---------------------------------------------------------
 
 
 ## On each worker node:
 
 open terminal on the worker node (or log in via SSH).
 
 ### Hot-linkcommand:
 ```
wget -qO - https://www.dropbox.com/s/kfsuo4bhku1h1oi/worker-node-setup.sh?dl=1  |  bash
 ```
 *if you don't want to use a hot-link you can download the "master-node-setup.sh" from the repository and run it from local path
 
 
 Wait until the execution finishes.
 
 
 # 3. Join the nodes to the cluser
 
 run on each node the join command you saved from the master node setup. run as a root - e.g 
 
  ```
  sudo sudo kubeadm join ....
  ```
 
 
 # 4. Verifying setup 
  
  run on the master node: 
 
  ```
  kubectl get nodes
  ```
  
  you should see something like this:

 ```
NAME               STATUS   ROLES                  AGE     VERSION
ip-172-31-67-91    Ready    <none>                 57s     v1.20.5
ip-172-31-69-75    Ready    <none>                 4m54s   v1.20.5
ip-172-31-76-203   Ready    control-plane,master   10m     v1.20.5
 ```
  
 # 5. Applying a Redis Config Map
 
 run on the master node: 
 
  ```
  kubectl apply -f  https://www.dropbox.com/s/qsradtlyjywxaod/redis-mapconfig.yaml?dl=1
  ```
 
 
 # 6. Deploying a Redis pod:
 
 run on the master node: 
 
  ```
  kubectl apply -f  https://www.dropbox.com/s/m0it8kx39kpvebg/redis-pod.yaml?dl=1
  ```
  
 # 7. Verifying the deployment
 
  run on the master node: 
 
  ```
  kubectl exec -it redis -- redis-cli
  ```
  
  this will enter into the redis-cli tool.
  authenticate:
  ```
  auth Tikal2021
  ```
  *"Tikal2021" is the defualt password applied by the config map file
  
  run some example commands:
  ```
  127.0.0.1:6379> set hello world
  OK
  127.0.0.1:6379> get hello
  "world"
  ```
  
  
  # DONE!
   now you have redis running on kubernetes with authentication and logging at DEBUG level.
   
   
   # To Do:
   
   ## Deploy Redis as an app with a service and a stateful set
   This is just an example of deploying a k8s cluster with redis running on top of it.
   However the pod is not persisted - meaning that the data will be lost as the pod die (as often happens).
   Therefore you need to change the deployment config files to deploy Redis as a [statful app.] (https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)
   this will presist the data and enables the user application access to the database from anywhere within the cluster.
   
   ## Harden the Redis deployment config
   more over you need to harden the Redis config by changing harmful commandes as suggested by [Redis documentation.](https://redis.io/topics/security)
   
   
   ## Close any unnecessary ports to the out side world
   As discused in the Redis[Redis documentation.](https://redis.io/topics/security) - Redis was not build to be exposed to the outside world and must be firewalled.
   
  
  
 
 
 
 
 
 
 
 
