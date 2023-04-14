#!/bin/bash
sed "s/tagversion/$1/g" pods.yaml > hello-pod.yaml