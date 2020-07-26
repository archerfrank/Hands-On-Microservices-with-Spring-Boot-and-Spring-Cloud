Kubernete


## API 

![kubernete](../imgs/6d8bfda7-c2b2-4b85-b4d7-5f30250bc9b9.png)

![kubernete](../imgs/cdf2a486-253b-4f11-abc7-2ee25e3694e6.png)

- kubectl get shows information about the specified API object.
- kubectl describe gives more detail about the specified API object.
- kubectl logs display log output from containers.


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
docker-compose exec product-composite bash
docker-compose down
docker-compose ps

curl -k https://localhost:8443/actuator/health

docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/health
docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/
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

下面这个不好用。。。
minikube.exe start -p handson-spring-boot-cloud --image-mirror-country cn --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.5.0.iso --registry-mirror=https://docker.mirrors.ustc.edu.cn --vm-driver="hyperv" --hyperv-virtual-switch="MinikubeSwitch" --memory=3000



minikube start -p handson-spring-boot-cloud

minikube profile handson-spring-boot-cloud
minikube start  --registry-mirror=https://qjsuih26.mirror.aliyuncs.com --vm-driver=virtualbox --memory=3000 

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

kubectl create namespace first-attempts
kubectl config set-context $(kubectl config current-context) --namespace=first-attempts

kubectl apply -f kubernetes/first-attempts/nginx-deployment.yaml

kubectl get all

kubectl delete pod --selector app=nginx-app

minikube ip

http://192.168.99.101:30080

kubectl apply -f kubernetes/first-attempts/nginx-service.yaml

kubectl run -i --rm --restart=Never curl-client --image=tutum/curl:alpine --command -- curl -s 'http://nginx-service:80'

kubectl get svc

## Legacy notes below.

http://localhost:9411/zipkin/   -- zipkin UI
https://localhost:8443/eureka/web 
http://localhost:15672/#/queues/%2F/zipkin -- rabbit queue management console

curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password

curl https://localhost:8443/product-composite/1 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU3NDU2MTQsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiJhNDFkOTEyYi1jMjJkLTQ3OGEtYmYyMy1hMDFlNDBiNzQyZGYiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.XAWj1R2PhdPNX_VFz5fu67SFIkCovfY4DS9QbV3GButJrzIy6dxupltZ7XawjfOtspk_7qXKEoyl2dkucE9_27sz9G4eHG8VstH-bADD7K47Mt_RuofYLKo2Afx7EMY3hWiUdwNlSrDvCyPS4yIw1iW-wHDjbA4VrMH3WgTamA_cx0GVF036-0ZuCpkUYMQ_Y5sxuZ0rPkf_5-M3PxISA8btuGJVZJB0qAqWQ6IgLK-a6qqe5TelVc-q-6CxOBjr70Yuj-xxZvuNrtq-c8k6lTpLn41FztI0W-47mpBEhXCAn10i7V1vuJ8N-RQcNTnGZ7f9VtKeUw9j0TjpEsDvCA" 

curl -k -i -X POST https://localhost:8443/product-composite -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU3NDU2MTQsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiJhNDFkOTEyYi1jMjJkLTQ3OGEtYmYyMy1hMDFlNDBiNzQyZGYiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.XAWj1R2PhdPNX_VFz5fu67SFIkCovfY4DS9QbV3GButJrzIy6dxupltZ7XawjfOtspk_7qXKEoyl2dkucE9_27sz9G4eHG8VstH-bADD7K47Mt_RuofYLKo2Afx7EMY3hWiUdwNlSrDvCyPS4yIw1iW-wHDjbA4VrMH3WgTamA_cx0GVF036-0ZuCpkUYMQ_Y5sxuZ0rPkf_5-M3PxISA8btuGJVZJB0qAqWQ6IgLK-a6qqe5TelVc-q-6CxOBjr70Yuj-xxZvuNrtq-c8k6lTpLn41FztI0W-47mpBEhXCAn10i7V1vuJ8N-RQcNTnGZ7f9VtKeUw9j0TjpEsDvCA"

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


