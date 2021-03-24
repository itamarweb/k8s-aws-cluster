# k8s-aws-cluster
 simple AWS kubernetes cluster













make sure these port ar open:

 | Protocol | Direction|	Port Range |	Purpose	|
 | ------------- | -------------|	------------- |	-------------	|
 | TCP |	Inbound |	6443 |	Kubernetes API server |
 | TCP	| Inbound |	2379-2380 |	etcd server client API |
 | TCP |	Inbound |	10250	| kubelet API |
 | TCP |	Inbound |	10251 |	kube-scheduler |
 | TCP |	Inbound |	10252 |	kube-controller-manager |
