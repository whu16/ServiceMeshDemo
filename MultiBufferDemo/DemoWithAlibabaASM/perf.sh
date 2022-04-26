#!/bin/bash

# Please change K6_CLOUD_TOKEN to your k6.io account API TOKEN.

if [ $2 = "cloud" ]; then
  if [ $1 = "disable" ]; then
    echo "Perf ASM gateway with multibuffer disabled"
  elif [ $1 = "enable" ]; then
    echo "Perf ASM gateway with multibuffer enabled"
  else
    echo "no support !"
  fi
  K6_CLOUD_TOKEN=d40072bce33f677c68c8d4b671206934b56f302794e2dda253468559be2a007a SERVER_HOST=$(kubectl --kubeconfig=./user_kube_config.conf  -n istio-system get pod -l app=istio-ingressgateway -o=jsonpath="{range .items[*]}{.status.podIP}{end}") k6 run --vus 50 --duration 30s --out cloud demo.js
elif [ $2 = "local" ]; then
  if [ $1 = "disable" ]; then
    echo "Perf ASM gateway with multibuffer disabled"
  elif [ $1 = "enable" ]; then
    echo "Perf ASM gateway with multibuffer enabled"
  else
    echo "no support !"
  fi
  SERVER_HOST=$(kubectl --kubeconfig=./user_kube_config.conf  -n istio-system get pod -l app=istio-ingressgateway -o=jsonpath="{range .items[*]}{.status.podIP}{end}") k6 run --vus 50 --duration 30s demo.js
else
 echo "no support !"
fi
