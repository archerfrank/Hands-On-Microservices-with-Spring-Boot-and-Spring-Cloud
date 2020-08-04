Kubernete
Ingress doesn't work in my PC, use NodePort instead.
Replacing Spring Cloud Config Server with Kubernetes config maps and secrets
Replacing Spring Cloud Gateway with a Kubernetes ingress resource
Deploying and testing the microservice landscape using Docker Compose to ensure that the source code in the microservices isn't locked into Kubernetes

## API 
virtualbox only can share C:/User folder to docker compose. Use it to map the volume.
## Executed script
minikube ip
gradlew.bat build -x test
minikube profile handson-spring-boot-cloud
minikube start -p handson-spring-boot-cloud

minikube start -p handson-spring-boot-cloud --image-mirror-country cn --registry-mirror=https://hub-mirror.c.163.com --vm-driver=virtualbox 


minikube docker-env
@FOR /f "tokens=*" %i IN ('minikube -p handson-spring-boot-cloud docker-env') DO @%i
docker-compose build

kubectl create namespace hands-on
kubectl config set-context handson-spring-boot-cloud --namespace=hands-on

kubectl create configmap config-repo --from-file=config-repo/ --save-config

kubectl create secret generic config-server-secrets --from-literal=ENCRYPT_KEY=my-very-secure-encrypt-key --from-literal=SPRING_SECURITY_USER_NAME=dev-usr --from-literal=SPRING_SECURITY_USER_PASSWORD=dev-pwd   --save-config

kubectl create secret generic config-client-credentials --from-literal=CONFIG_SERVER_USR=dev-usr --from-literal=CONFIG_SERVER_PWD=dev-pwd --save-config

docker pull mongo:3.6.9
docker pull rabbitmq:3.7.26-management-alpine

docker pull elasticsearch:7.8.1
docker pull kibana:7.8.1

docker pull docker.elastic.co/elasticsearch/elasticsearch-oss:7.3.0
docker pull docker.elastic.co/kibana/kibana-oss:7.3.0

kubectl apply -k kubernetes/services/overlays/dev
kubectl wait --timeout=900s --for=condition=ready pod --all

kubectl get pods -o json | jq .items[].spec.containers[].image

kubectl logs -f product-composite-777567f846-hks8t

https://192.168.99.105:30080/actuator/health
https://192.168.99.105:18443/actuator/health

curl -k http://minikube.me:30080/product-composite/1 
curl -k http://minikube.me:30080/actuator/health
curl -k http://minikube.me:30080/product-composite/1 

curl -k -i -X POST http://minikube.me:30080/product-composite -d @data.json -H "Content-Type: application/json" 

kubectl delete namespace hands-on

kubectl get configmap config-repo
kubectl describe cm config-repo

kubectl exec -it podName  -c  containerName -n namespace -- shell comand


kubectl exec -it product-composite-f5dfb9c65-lxj56  -c  k8s_comp_product-composite-f5dfb9c65-lxj56_hands-on_75276020-d142-4904-b672-e35c2b9137b0_0 -- curl 'http://product-composite:80/1'

kubectl run -i --rm --restart=Never curl-client --image=tutum/curl:alpine --command --curl 'http://product-composite:80/1'

## Go to production

1. Resource managers should run outside of the Kubernetes cluster: It is technically feasible to run databases and queue managers for production use on Kubernetes as stateful containers using StatefulSets and PersistentVolumes. At the time of writing this chapter, I recommend against it, mainly because the support for stateful containers is relatively new and unproven in Kubernetes. Instead, I recommend using the existing database and queue manager services on premises or managed services in the cloud, leaving Kubernetes to do what it is best for, that is, running stateless containers. For the scope of this book, to simulate a production environment, we will run MySQL, MongoDB, and RabbitMQ as plain Docker containers outside of Kubernetes using the already existing Docker Compose files.
2. Lockdown:
For security reasons, things like actuator endpoints and log levels need to be constrained in a production environment.
Externally exposed endpoints should also be reviewed from a security perspective. For example, access to the configuration server should most probably be locked down in a production environment, but we will keep it exposed in this book for convenience.
Docker image tags must be specified to be able to track which versions of the microservices have been deployed.

```
eval $(minikube docker-env)
docker-compose up -d mongodb mysql rabbitmq

docker tag hands-on/auth-server hands-on/auth-server:v1
docker tag hands-on/config-server hands-on/config-server:v1
docker tag hands-on/gateway hands-on/gateway:v1 
docker tag hands-on/product-composite-service hands-on/product-composite-service:v1 
docker tag hands-on/product-service hands-on/product-service:v1
docker tag hands-on/recommendation-service hands-on/recommendation-service:v1
docker tag hands-on/review-service hands-on/review-service:v1

kubectl create namespace hands-on
kubectl config set-context $(kubectl config current-context) --namespace=hands-on

kubectl create configmap config-repo --from-file=config-repo/ --save-config

kubectl create secret generic config-server-secrets \
  --from-literal=ENCRYPT_KEY=my-very-secure-encrypt-key \
  --from-literal=SPRING_SECURITY_USER_NAME=prod-usr \
  --from-literal=SPRING_SECURITY_USER_PASSWORD=prod-pwd \
  --save-config

kubectl create secret generic config-client-credentials \
--from-literal=CONFIG_SERVER_USR=prod-usr \
--from-literal=CONFIG_SERVER_PWD=prod-pwd --save-config


history -c; history -w

kubectl apply -k kubernetes/services/overlays/prod
```
## Rolling update

```
kubectl get pod -l app=product -o jsonpath='{.items[*].spec.containers[*].image} '

docker tag hands-on/product-service:v1 hands-on/product-service:v2

kubectl get pod -l app=product -w

failed rolling
kubectl set image deployment/product pro=hands-on/product-service:v3
```

## Build script
```
SET COMPOSE_FILE=docker-compose.yml
SET COMPOSE_FILE=docker-compose-partitions.yml
SET COMPOSE_FILE=docker-compose-kafka.yml

gradlew.bat build -x test
docker-compose build
docker-compose up -d
docker-compose logs -f --tail=0 gateway
docker-compose logs -f gateway
docker exec -it chapter12_config-server_1 bash
docker-compose exec config-server bash
docker-compose down
docker-compose ps

curl -k https://localhost:8443/actuator/health

docker run --rm -it --network=my-network alpine wget product-composite:80/actuator/health
docker run --rm -it --network=my-network alpine wget gateway:8443/actuator/health
docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/health -qO - | jq -r .details.productCircuitBreaker.details.state

circuitbreakerevents/product/STATE_TRANSITION
curl product-composite:8080/actuator/health
curl product-composite:8080/actuator/circuitbreakerevents/product/STATE_TRANSITION 
curl product-composite:8080/actuator/retryevents
```
##  Testing script

### Testing
bcdedit /set hypervisorlaunchtype auto
bcdedit /set hypervisorlaunchtype off
--engine-registry-mirror=https://qjsuih26.mirror.aliyuncs.com



minikube start -p handson-spring-boot-cloud

minikube profile handson-spring-boot-cloud

minikube start   -p handson-spring-boot-cloud --image-mirror-country cn --registry-mirror=https://qjsuih26.mirror.aliyuncs.com --vm-driver=virtualbox 


minikube start  -p handson-spring-boot-cloud --image-mirror-country cn --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.5.0.iso --registry-mirror=https://docker.mirrors.ustc.edu.cn --vm-driver=virtualbox --memory=3000 

minikube delete
minikube config get profile

minikube dashboard
minikube stop

minikube addons enable ingress
minikube addons enable metrics-server

kubectl config use-context docker-for-desktop
kubectl config get-contexts 
kubectl config use-context my-cluster

kubectl get pods --namespace=kube-system

kubectl get nodes

kubectl get all

kubectl delete pod --selector app=nginx-app

minikube ip



kubectl get svc

## Legacy notes below.

http://localhost:9411/zipkin/   -- zipkin UI
https://localhost:8443/eureka/web 
http://localhost:15672/#/queues/%2F/zipkin -- rabbit queue management console

curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password

curl -k https://192.168.99.105:18443/product-composite/1 

curl -k -i -X POST https://192.168.99.105:18443/product-composite -d @data.json -H "Content-Type: application/json" 

curl -X DELETE -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU3NDU2MTQsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiJhNDFkOTEyYi1jMjJkLTQ3OGEtYmYyMy1hMDFlNDBiNzQyZGYiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.XAWj1R2PhdPNX_VFz5fu67SFIkCovfY4DS9QbV3GButJrzIy6dxupltZ7XawjfOtspk_7qXKEoyl2dkucE9_27sz9G4eHG8VstH-bADD7K47Mt_RuofYLKo2Afx7EMY3hWiUdwNlSrDvCyPS4yIw1iW-wHDjbA4VrMH3WgTamA_cx0GVF036-0ZuCpkUYMQ_Y5sxuZ0rPkf_5-M3PxISA8btuGJVZJB0qAqWQ6IgLK-a6qqe5TelVc-q-6CxOBjr70Yuj-xxZvuNrtq-c8k6lTpLn41FztI0W-47mpBEhXCAn10i7V1vuJ8N-RQcNTnGZ7f9VtKeUw9j0TjpEsDvCA" -k https://localhost:8443/product-composite/1 -w "%{http_code}\n" -o /dev/null -s

### Testing with Kafka

```
SET COMPOSE_FILE=docker-compose-kafka.yml
docker-compose up -d
curl -k https://localhost:8443/actuator/health
docker-compose exec kafka /opt/kafka/bin/kafka-topics.sh --zookeeper zookeeper --list
docker-compose exec kafka /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic zipkin --from-beginning --timeout-ms 1000
```


### Gateway call
```
curl localhost:8443/actuator/gateway/routes 
```

Some more testing

```
curl -k https://localhost:8443/actuator/health

```

### Eureka Server
https://localhost:8443/eureka/web

curl -k -H "accept:application/json" https://u:p@localhost:8443/eureka/apps

Rabbitmq

http://localhost:15672


