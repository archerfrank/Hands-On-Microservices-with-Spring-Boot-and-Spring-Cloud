Kubernete


## API 

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

kubectl apply -k kubernetes/services/overlays/dev
kubectl wait --timeout=900s --for=condition=ready pod --all

kubectl get pods -o json | jq .items[].spec.containers[].image

kubectl logs -f gateway-66648bcc85-w9jkw 

https://192.168.99.105:31443/actuator/health
https://192.168.99.105:18443/actuator/health

curl -k https://192.168.99.105:31443/product-composite/1 

curl -k -i -X POST https://192.168.99.105:31443/product-composite -d @data.json -H "Content-Type: application/json" 

kubectl delete namespace hands-on

kubectl get configmap config-repo
kubectl describe cm config-repo

kubectl run -i --rm --restart=Never curl-client --image=tutum/curl:alpine --command --curl 'http://product-composite:80/1'

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


