# Create resource in Alibaba cloud
  1. create a VPC and a vSwitch, all the following resources need use this VPC and vSwitch.
  2. create an ACK Kubernetes cluster with 2 nodes, node profile must be g7 profile Ice Lake platform, ACK Pro, K8S version 1.20.11-aliyun.1, runtime Docker 19.03.15; make sure SNAT enabled for worker node to access internet to pull image. 
  3. create an ASM Pro version, Istio version 1.11.540, attach ACK Kubernetes cluster in step2 as data plane.  
  4. create an ECS instance as kubectl and k6 client.

## ECS setup
1. Connect the ECS client using workbench and you need add security group for connection. 
```shell
    yum install -y git
    git clone https://github.com/whu16/ServiceMeshDemo.git
```    
2. Create user_kube_config.conf and asm_kube_config.conf. Copy ACK Kubernetes cluster kubeconfig and ASM kubeconfig in their connection information page into the conf files. **Please note the ACK kubernetes cluster kubeconfig has expiration time at most 3 days. You can't connect cluster after that. 
   
3. make install   //install kubectl and k6
4. make k8resource  // apply yaml files for k8s resources
5. Check K8s resources readiness
6. export KUBECONFIG=`pwd`/user_kube_config.conf to use kubectl

## Test K6
1.  apply account in k6.io and get the API token from your account, modify the perf.sh to set up the correct API token
4.  make perf_disable
5.  turn on MultiBuffer at ASM Settings page to checkbox the multibuffer
4.  delete the istio-ingressgateway pod under istio-system name space. The pod will auto recovery.
5.  make perf_enable
6.  The k6 test results will upload to k6.io automatically. 