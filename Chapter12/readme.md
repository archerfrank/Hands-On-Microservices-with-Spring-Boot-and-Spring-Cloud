The config server is added.
The authserver is added.
The gateway is added.
The eureka server is added. Please look at the product composite project. 

```java
	@Bean
	@LoadBalanced
	public WebClient.Builder loadBalancedWebClientBuilder() {
		final WebClient.Builder builder = WebClient.builder();
		return builder;
	}
```

## API 

/actuator: The standard actuator endpoints exposed by all microservices. As always, these should be used with care. They are very useful during development but must be locked down before being used in production.

/encrypt and /decrypt: Endpoints for encrypting and decrypting sensitive information. These must also be locked down before being used in production.

/{microservice}/{profile}: Returns the configuration for the specified microservice and the specified Spring profile.

```yml
- id: config-server
  uri: http://${app.config-server}:8888
  predicates:
  - Path=/config/**
  filters:
  - RewritePath=/config/(?<segment>.*), /$\{segment}
```

The RewritePath filter in the preceding routing rule will remove the leading part, /config, from the incoming URL before it sends it to the config server.

The values of the three preceding environment variables defined are fetched by Docker Compose from the .env file:

```s
CONFIG_SERVER_ENCRYPT_KEY=my-very-secure-encrypt-key
CONFIG_SERVER_USR=dev-usr
CONFIG_SERVER_PWD=dev-pwd
```


## Build script
```
SET COMPOSE_FILE=docker-compose.yml
SET COMPOSE_FILE=docker-compose-partitions.yml
SET COMPOSE_FILE=docker-compose-kafka.yml
SET COMPOSE_FILE=docker-compose-openid.yml
SET CONFIG_SERVER_USR=dev-usr
SET CONFIG_SERVER_PWD=dev-pwd

gradlew.bat build -x test
docker-compose build
docker-compose up -d
docker-compose logs -f --tail=0 gateway
docker-compose logs -f product
docker exec -it chapter12_config-server_1 bash
docker-compose exec config-server bash
docker-compose down
docker-compose ps
```
##  Testing script

### Testing
https://localhost:8443/eureka/web 
curl https://dev-usr:dev-pwd@localhost:8443/config/product/docker -k
curl https://dev-usr:dev-pwd@localhost:8443/config/product/default -k
curl -k https://dev-usr:dev-pwd@localhost:8443/config/encrypt --data-urlencode "hello world"
curl -k https://dev-usr:dev-pwd@localhost:8443/config/decrypt -d 04cc1e6d63167d2b652331a80f31805e8620940dfac90d2023059144ce2f3ab4

### Get Token
#### password grant flow
```
curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 

curl -k https://read:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 
```
Use the token to access the protected API
```
curl https://localhost:8443/product-composite/1 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2Njg1NTUsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiI5ZTBhYWQwNS0xODg2LTQ2OWUtYjczYi0zZjg0NWY3YzYyZTQiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.RcoYx3hiIlvTdlzvAAyhdTwoixZBCJzJ-LE0TGdImT0x5QyZ7t-ScwNehMQ-v6JuBFUJ4S4jlM44cd6VFUqLJG7aoqEUWBPh1vVuV_YrSXuDPNkmKRcCwkZ5p1FmAXTZQBnLaDw9UOM0n3E1cjP9mIET8LbMPY2cOFxIRaf0eB3WR8tJpZn006rL2EpgPw3rOXv0mwUWAx1TcabpK5iwgq7Zs80XsB4dAIyWVOheP0wKxm4HgVHoawcu4cRbHCNHHgq1HEUWLiKFRUgsV41Hnx-mOY5ywF0C2wjoEXsa1Me_7aOqMAlAo9wuKt4cdhVID5Tg66OiqKDRXd6Ypkfbbg" 

curl -k -i -X POST https://localhost:8443/product-composite -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2Njg1NTUsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiI5ZTBhYWQwNS0xODg2LTQ2OWUtYjczYi0zZjg0NWY3YzYyZTQiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.RcoYx3hiIlvTdlzvAAyhdTwoixZBCJzJ-LE0TGdImT0x5QyZ7t-ScwNehMQ-v6JuBFUJ4S4jlM44cd6VFUqLJG7aoqEUWBPh1vVuV_YrSXuDPNkmKRcCwkZ5p1FmAXTZQBnLaDw9UOM0n3E1cjP9mIET8LbMPY2cOFxIRaf0eB3WR8tJpZn006rL2EpgPw3rOXv0mwUWAx1TcabpK5iwgq7Zs80XsB4dAIyWVOheP0wKxm4HgVHoawcu4cRbHCNHHgq1HEUWLiKFRUgsV41Hnx-mOY5ywF0C2wjoEXsa1Me_7aOqMAlAo9wuKt4cdhVID5Tg66OiqKDRXd6Ypkfbbg"

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


