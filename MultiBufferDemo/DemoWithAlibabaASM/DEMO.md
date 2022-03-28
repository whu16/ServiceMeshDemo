# create resource in Alibaba cloud
  1. create a VPC and a vSwitch, all the following resources use this VPC and vSwitch.
  2. create an ACK Kubernetes cluster with 2 nodes, node profile must be g7 profile Ice Lake platform, ACK Pro, K8S version 1.20.11-aliyun.1, runtime Docker 19.03.15; make sure SNAT enabled for worker node to access internet to pull image. 
  3. create an ASM Pro version, Istio version 1.11.540,attach ACK Kubernetes cluster as data plane.  
  4. create an ECS instance as kubectl and k6 client.

## ECS setup
1. Add security group and public EIP for ECS instance, ssh to ECS
      1.1 yum install -y git
      1.2 git clone https://github.com/whu16/ServiceMeshDemo.git
2. Create user_kube_config.conf and asm_kube_config.conf by copy ACK Kubernetes cluster kubeconfig and ASM kubeconfig
3. make install
4. Check K8s resources readiness
5. install k6
      5.1 yum install https://dl.k6.io/rpm/repo.rpm
      5.2 yum install --nogpgcheck k6

6. export KUBECONFIG=kubeconf to use kubectl

## Test K6
1.  make perf_disable/make perf_enable
2.  apply account in k6.io and get the API token from your account
3.  modify the perf.sh to set up the correct API token
4.  make perf_disable
5.  turn on MultiBuffer at ASM setup page 右上角功能设置 to checkbox the multibuffer
4.  delete the istio-ingressgateway under istiosystem name space. The gateway will auto recovery.
5.  make perf_enable
6.  you will have 2 times tests at k6.io
  