# Docker file for HBase

Minimal docker kerberos secured HBase server for testing purposes.\
Please be aware that kerberos is not embedded so [docker KDC](https://github.com/gaborgsomogyi/docker-kdc) is needed.

## How to build
```
eval $(minikube docker-env)
docker build -t gaborgsomogyi/hbase:latest .
```

## How to run
Here one can choose from 2 deployments:
* K8S
```
mkdir -p ${HOME}/share
minikube start --mount-string="${HOME}/share:/share" --mount
kubectl apply -f hbase.yaml
kubectl delete pod/hbase
```

* Docker
```
./run-hbase.sh
```

## Access the container
* K8S
```
kubectl exec -it hbase -- bash
```

* Docker
```
docker exec -it hbase bash
```
