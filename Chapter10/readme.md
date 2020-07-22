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
docker-compose logs -f
docker-compose down
docker-compose ps

docker-compose up -d --scale review=3
docker-compose up -d --scale review=2
docker-compose up -d --scale review=2 --scale eureka=0
docker-compose up -d --scale review=1 --scale eureka=0
docker-compose up -d --scale review=1 --scale eureka=0 --scale product=2
docker-compose up -d --scale review=1 --scale eureka=1 --scale product=2
```
##  Testing script
Eureka Server
http://localhost:8761/
curl -H "accept:application/json" http://localhost:8761/eureka/apps


Create one product
```
curl -X POST http://localhost:8080/product-composite -H "Content-Type: application/json" -d @data.json

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

curl localhost:8080/product-composite/2 -s
curl localhost:8080/product-composite/1


Delete a product
```
curl -X DELETE localhost:8080/product-composite/1
```

Rabbitmq

http://localhost:15672