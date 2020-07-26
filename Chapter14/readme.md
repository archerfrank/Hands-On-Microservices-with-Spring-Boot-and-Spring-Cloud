Resilience4j
The config server is added.
The authserver is added.
The gateway is added.
The eureka server is added. Please look at the product composite project. 


## API 

![zipkin](../imgs/0006d41f-9f89-4f39-a1ca-8d3971451602.png)


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
http://localhost:9411/zipkin/
https://localhost:8443/eureka/web 
http://localhost:15672/#/queues/%2F/zipkin

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




### Get Token
#### password grant flow
```
curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 

curl -k https://read:secret@curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 
```
Use the token to access the protected API
```
curl https://localhost:8443/product-composite/1 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2OTE2NDksImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIwNzZkZDMyMC00NTBlLTQxYjYtYWYyOC02YTE1NTM3ZjBmNDAiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.VTXCI-X88iJ4fZCkKwlf1vVgz2Rmky_DkJK_PqLOx-mPRQPHxIX_-nFy5_XDcK7e8tlaf82qb1pxLOxwRJqm3RvTK8_RE8oRhRz-d1pEmbZWrgNky6PEpHl9PVruT3Kxaxe4kDa-Jv2Asfb92TGyvZY1-LIea9l1XNK10ze66XNH3JibqSmLGGkScpt6bYIWQKOSZhKKz18WWMJynEk3medsfV8COC-97xT7SyPUDLB4CDEEfd1HoVsr-NSCF8whyxCYlil69-QAk1HuSqQ8ZaYSHS0torO1cevTxBQPXVh5utfTk5NINSoJiCMcEb8ACgCpw33eZpCKr5LAqZ-xvg" 

curl -k -i -X POST https://localhost:8443/product-composite -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2OTE2NDksImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIwNzZkZDMyMC00NTBlLTQxYjYtYWYyOC02YTE1NTM3ZjBmNDAiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.VTXCI-X88iJ4fZCkKwlf1vVgz2Rmky_DkJK_PqLOx-mPRQPHxIX_-nFy5_XDcK7e8tlaf82qb1pxLOxwRJqm3RvTK8_RE8oRhRz-d1pEmbZWrgNky6PEpHl9PVruT3Kxaxe4kDa-Jv2Asfb92TGyvZY1-LIea9l1XNK10ze66XNH3JibqSmLGGkScpt6bYIWQKOSZhKKz18WWMJynEk3medsfV8COC-97xT7SyPUDLB4CDEEfd1HoVsr-NSCF8whyxCYlil69-QAk1HuSqQ8ZaYSHS0torO1cevTxBQPXVh5utfTk5NINSoJiCMcEb8ACgCpw33eZpCKr5LAqZ-xvg"

curl -H "Authorization: Bearer $ACCESS_TOKEN" -k https://localhost:8443/product-composite/2?faultPercent=25

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


