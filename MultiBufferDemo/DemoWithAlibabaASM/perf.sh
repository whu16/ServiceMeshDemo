#!/bin/bash

if [ $1 = "disable" ]; then
 echo "Perf ASM gateway with multibuffer disabled"
 K6_CLOUD_TOKEN=5f90d5767ea365a860c612039afac9207089a30bc69876a01a12025af29bd7a6 SERVER_HOST=$(kubectl --kubeconfig=./user_kube_config.conf  -n istio-system get pod -l app=istio-ingressgateway -o=jsonpath="{range .items[*]}{.status.podIP}{end}") k6 run --vus 50 --duration 10s --out cloud demo.js
elif [ $1 = "enable" ]; then
 echo "Perf ASM gateway with multibuffer enabled"
 K6_CLOUD_TOKEN=5f90d5767ea365a860c612039afac9207089a30bc69876a01a12025af29bd7a6 SERVER_HOST=$(kubectl --kubeconfig=./user_kube_config.conf  -n istio-system get pod -l app=istio-ingressgateway -o=jsonpath="{range .items[*]}{.status.podIP}{end}") k6 run --vus 50 --duration 10s --out cloud demo.js
else
 echo "no support !"
fi
