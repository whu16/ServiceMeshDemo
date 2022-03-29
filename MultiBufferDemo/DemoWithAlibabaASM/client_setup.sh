#!/bin/bash

# setup K6 client
yum install https://dl.k6.io/rpm/repo.rpm
yum install --nogpgcheck k6

# git clone the scripts
git clone https://github.com/whu16/ServiceMeshDemo.git

