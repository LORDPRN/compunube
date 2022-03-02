#!/bin/bash
echo "aplicando cluster..."
cat preseed.yaml | lxd init --preseed
echo "cluster aplicado exitosamente"
