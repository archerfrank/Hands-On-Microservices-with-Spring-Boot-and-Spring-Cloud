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
This is an example with Mongo DB and Mysql and Cloud stream, it is an asynchronized WebFlux Reactor implementation.


## Build script
```
SET COMPOSE_FILE=docker-compose.yml
SET COMPOSE_FILE=docker-compose-partitions.yml
SET COMPOSE_FILE=docker-compose-kafka.yml

gradlew.bat build -x test
docker-compose build
docker-compose up -d
docker-compose logs -f --tail=0 gateway
docker-compose down
docker-compose ps
```
##  Testing script
### HTTPS Testing
https://localhost:8443/eureka/web 

### Get Token

#### password grant flow
```
curl -k https://writer:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 

curl -k https://read:secret@localhost:8443/oauth/token -d grant_type=password -d username=magnus -d password=password 

ACCESS_TOKEN={a-reader-access-token}
curl https://localhost:8443/product-composite/2 -k -H "Authorization: Bearer $ACCESS_TOKEN" -i 
```
Use the token to access the protected API
```
curl https://localhost:8443/product-composite/1 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU1MjIyODIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiI2ODI0NTUxOS0zZGI1LTQ5YWMtYjU0OC1jNDI4NzJiNTYwYzIiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.DIAxEyl0-5LQA8aGKJdy8pGEFUDu0g3DtVS13qF8tn2lVqD3Hwoom7SODEk0mQCwv-58CQTRR4Wzb4q3GYtmqr9NT8AxQNLww38BKQjdVK8c21BxE_xic0XPC_rmkCXtKe8wjYx-JIbF7aa2txdb6DixjzzQ-ow8is-amQRxkR3ORevj_Moj88yZ_uHk6ptgkmcuS2u5fgpN4k9nXXsbJ4h027Ukudq5j0YvNIV_z6sK4dgnr6_mBvtYdvMTVBuXZGm3gPVH8F2h02jZqUi3f2irq118i_JQHvag0vp7pSIZFx2HUs4Oo0fwL7oNLVKXBaivrcb5uA_CvRt-bh_tAw" 

curl -k -i -X POST https://localhost:8443/product-composite -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU1MjIyODIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiI2ODI0NTUxOS0zZGI1LTQ5YWMtYjU0OC1jNDI4NzJiNTYwYzIiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.DIAxEyl0-5LQA8aGKJdy8pGEFUDu0g3DtVS13qF8tn2lVqD3Hwoom7SODEk0mQCwv-58CQTRR4Wzb4q3GYtmqr9NT8AxQNLww38BKQjdVK8c21BxE_xic0XPC_rmkCXtKe8wjYx-JIbF7aa2txdb6DixjzzQ-ow8is-amQRxkR3ORevj_Moj88yZ_uHk6ptgkmcuS2u5fgpN4k9nXXsbJ4h027Ukudq5j0YvNIV_z6sK4dgnr6_mBvtYdvMTVBuXZGm3gPVH8F2h02jZqUi3f2irq118i_JQHvag0vp7pSIZFx2HUs4Oo0fwL7oNLVKXBaivrcb5uA_CvRt-bh_tAw"

```
#### implicit grant flow

```
https://localhost:8443/oauth/authorize?response_type=token&client_id=reader&redirect_uri=http://my.redirect.uri&scope=product:read&state=48532

magnus
password

Copy the URL 


```

#### code grant flow
```
https://localhost:8443/oauth/authorize?response_type=code&client_id=reader&redirect_uri=http://my.redirect.uri&scope=product:read&state=35725

Copy url http://my.redirect.uri/?code=sXdQrb&state=35725

curl -k https://reader:secret@localhost:8443/oauth/token -d grant_type=authorization_code -d client_id=reader -d redirect_uri=http://my.redirect.uri -d code=sXdQrb
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

### General testing
Create one product
```
curl -k -X POST https://localhost:8443/product-composite -H "Content-Type: application/json" -d @data.json

http://localhost:8080/product-composite/

Host: localhost:8080
Connection: keep-alive
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 2
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9
Content-Type: application/json
Content-Length: 610



{"productId":1,"name":"product 1","weight":1, "recommendations":[
        {"recommendationId":1,"author":"author 1","rate":1,"content":"content 1"},
        {"recommendationId":2,"author":"author 2","rate":2,"content":"content 2"},
        {"recommendationId":3,"author":"author 3","rate":3,"content":"content 3"}
    ], "reviews":[
        {"reviewId":1,"author":"author 1","subject":"subject 1","content":"content 1"},
        {"reviewId":2,"author":"author 2","subject":"subject 2","content":"content 2"},
        {"reviewId":3,"author":"author 3","subject":"subject 3","content":"content 3"}
    ]}
```

View a product

http://localhost:8080/product-composite/2
```
curl -k https://localhost:8443/product-composite/2
curl -k https://localhost:8443/product-composite/1
```

Delete a product
```
curl -X DELETE localhost:8080/product-composite/1
```

Rabbitmq

http://localhost:15672