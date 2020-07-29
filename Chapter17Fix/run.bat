minikube start -p handson-spring-boot-cloud --image-mirror-country cn --registry-mirror=https://hub-mirror.c.163.com --vm-driver=virtualbox 

@FOR /f "tokens=*" %i IN ('minikube -p handson-spring-boot-cloud docker-env') DO @%i

gradlew.bat build -x test

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