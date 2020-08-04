minikube start -p handson-spring-boot-cloud --image-mirror-country cn --registry-mirror=https://hub-mirror.c.163.com --vm-driver=virtualbox 

@FOR /f "tokens=*" %i IN ('minikube -p handson-spring-boot-cloud docker-env') DO @%i

gradlew.bat build -x test

docker-compose build
kubectl get namespace

kubectl create namespace logging

kubectl config set-context handson-spring-boot-cloud --namespace=logging

kubectl apply -f kubernetes/efk/elasticsearch.yml -n logging

curl http://minikube.me:30204 -s | jq -r .tagline



docker build -f kubernetes/efk/Dockerfile -t hands-on/fluentd:v1 kubernetes/efk/

kubectl apply -f kubernetes/efk/fluentd-hands-on-configmap.yml 
kubectl apply -f kubernetes/efk/fluentd-ds.yml

kubectl replace --force -f xxxx.yaml  /// 重启pod

kubectl logs -n kube-system $(kubectl get pod -l app=fluentd -n kube-system -o jsonpath={.items..metadata.name}) | grep "fluentd worker is now running worker"
kubectl logs -n kube-system fluentd-hlw8s
curl http://minikube.me:31385/_all/_count    



kubectl create namespace hands-on

kubectl config set-context handson-spring-boot-cloud --namespace=hands-on

kubectl create configmap config-repo-auth-server       --from-file=config-repo/application.yml --from-file=config-repo/auth-server.yml --save-config
kubectl create configmap config-repo-gateway           --from-file=config-repo/application.yml --from-file=config-repo/gateway.yml --save-config
kubectl create configmap config-repo-product-composite --from-file=config-repo/application.yml --from-file=config-repo/product-composite.yml --save-config
kubectl create configmap config-repo-product           --from-file=config-repo/application.yml --from-file=config-repo/product.yml --save-config
kubectl create configmap config-repo-recommendation    --from-file=config-repo/application.yml --from-file=config-repo/recommendation.yml --save-config
kubectl create configmap config-repo-review            --from-file=config-repo/application.yml --from-file=config-repo/review.yml --save-config

kubectl create secret generic rabbitmq-server-credentials     --from-literal=RABBITMQ_DEFAULT_USER=rabbit-user-dev     --from-literal=RABBITMQ_DEFAULT_PASS=rabbit-pwd-dev     --save-config

kubectl create secret generic rabbitmq-credentials     --from-literal=SPRING_RABBITMQ_USERNAME=rabbit-user-dev     --from-literal=SPRING_RABBITMQ_PASSWORD=rabbit-pwd-dev     --save-config

kubectl create secret generic rabbitmq-zipkin-credentials     --from-literal=RABBIT_USER=rabbit-user-dev     --from-literal=RABBIT_PASSWORD=rabbit-pwd-dev     --save-config

kubectl create secret generic mongodb-server-credentials     --from-literal=MONGO_INITDB_ROOT_USERNAME=mongodb-user-dev     --from-literal=MONGO_INITDB_ROOT_PASSWORD=mongodb-pwd-dev     --save-config

kubectl create secret generic mongodb-credentials     --from-literal=SPRING_DATA_MONGODB_AUTHENTICATION_DATABASE=admin     --from-literal=SPRING_DATA_MONGODB_USERNAME=mongodb-user-dev     --from-literal=SPRING_DATA_MONGODB_PASSWORD=mongodb-pwd-dev     --save-config

kubectl create secret generic mysql-server-credentials     --from-literal=MYSQL_ROOT_PASSWORD=rootpwd     --from-literal=MYSQL_DATABASE=review-db     --from-literal=MYSQL_USER=mysql-user-dev     --from-literal=MYSQL_PASSWORD=mysql-pwd-dev     --save-config

kubectl create secret generic mysql-credentials     --from-literal=SPRING_DATASOURCE_USERNAME=mysql-user-dev     --from-literal=SPRING_DATASOURCE_PASSWORD=mysql-pwd-dev     --save-config

kubectl create secret tls tls-certificate --key kubernetes/cert/tls.key --cert kubernetes/cert/tls.crt

kubectl describe cm config-repo

@FOR /f "tokens=*" %i IN ('minikube -p handson-spring-boot-cloud docker-env') DO @%i

docker pull mongo:3.6.9
docker pull rabbitmq:3.7.26-management-alpine
docker tag hands-on/product-composite-service hands-on/product-composite-service:v1 

kubectl apply -k kubernetes/services/overlays/dev
kubectl wait --timeout=900s --for=condition=ready pod --all

minikube tunnel

REM add minikube in window/driver/etc
curl -k http://minikube.me:30080/product-composite/1 
curl -k http://minikube.me:30080/actuator/health
curl -k http://minikube.me:30080/product-composite/1 
curl -k -i -X POST http://minikube.me:30080/product-composite -d @data.json -H "Content-Type: application/json" 


kubectl delete namespace hands-on

kubectl apply -f kubernetes/efk/kibana.yml -n logging

curl -o /dev/null -s -L -w "%{http_code}\n" http://minikube.me:30065


kubectl delete namespace logging




minikube stop