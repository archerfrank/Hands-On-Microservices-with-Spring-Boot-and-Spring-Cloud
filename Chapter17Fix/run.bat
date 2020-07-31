minikube start -p handson-spring-boot-cloud --image-mirror-country cn --registry-mirror=https://hub-mirror.c.163.com --vm-driver=virtualbox 

@FOR /f "tokens=*" %i IN ('minikube -p handson-spring-boot-cloud docker-env') DO @%i

gradlew.bat build -x test

docker-compose build

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