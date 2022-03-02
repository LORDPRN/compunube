#!/bin/bash
echo "uniendose a nodo1"
cat preseed2.yaml | sudo lxd init --preseed
echo "clustering hecho"
sleep 5
