#!/bin/bash
echo "uniendose a nodo1"
cat preseed3.yaml | sudo lxd init --preseed
echo "clustering hecho"
sleep 5

