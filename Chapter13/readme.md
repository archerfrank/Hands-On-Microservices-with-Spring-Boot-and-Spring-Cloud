Resilience4j
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

* The current state of a circuit breaker can be monitored using the microservice's actuator health endpoint, **/actuator/health.**
* The circuit breaker also publishes events on an actuator endpoint, for example, state transitions,**/actuator/circuitbreakerevents.**
* Finally, circuit breakers are integrated with Spring Boot's metrics system and can use it to publish metrics to monitoring tools such as Prometheus.

## Circuit Breaker

- **ringBufferSizeInClosedState**: Number of calls in a closed state, which are used to determine whether the circuit shall be opened.
- 
- **failureRateThreshold**: The threshold, in percent, for failed calls that will cause the circuit to be opened.
- 
- **waitInterval**: Specifies how long the circuit stays in an open state, that is, before it transitions to the half-open state.
- 
- **ringBufferSizeInHalfOpenState**: The number of calls in the half-open state that are used to determine whether the circuit shall be opened again or go back to the normal, closed state.
- automaticTransitionFromOpenToHalfOpenEnabled: Determines whether the circuit automatically will transition to half-open once the wait period is over or wait for the first call after the waiting period until it transitions to the half-open state.

**ignoreExceptions**: Can be used to specify exceptions that should not be counted as faults. Expected business exceptions such as not found or invalid input are typical exceptions that the circuit breaker should ignore, that is, users that search for non-existing data or enter invalid input should not cause the circuit to open.

In this example,

- ringBufferSizeInClosedState = 5 and failureRateThreshold = 50%, meaning that if three or more of the last five calls are faults, then the circuit will open.
- waitInterval = 10000 and automaticTransitionFromOpenToHalfOpenEnabled = true, meaning that the circuit breaker will keep the circuit open for 10 seconds and then transition to the half-open state.
- ringBufferSizeInHalfOpenState = 3, meaning that the circuit breaker will decide whether the circuit shall be opened or closed based on the three first calls after the circuit has transitioned to the half-open state. Since the failureRateThreshold parameters are set to 50%, the circuit will be open again if two or all three calls fail. Otherwise, the circuit will be closed.
- ignoreExceptions = InvalidInputException and NotFoundException, meaning that our two business exceptions will not be counted as faults in the circuit breaker.

The circuit breaker is triggered by an exception, not by a timeout itself. To be able to trigger the circuit breaker after a timeout, we have to add code that generates an exception after a timeout. Using WebClient, which is based on Project Reactor, allows us to do that conveniently by using its timeout(Duration) method. The source code looks as follows:

```java
@CircuitBreaker(name = "product")
public Mono<Product> getProduct(int productId, int delay, int faultPercent) {
    ...
    return getWebClient().get().uri(url)
        .retrieve().bodyToMono(Product.class).log()
        .onErrorMap(WebClientResponseException.class, ex -> 
         handleException(ex))
        .timeout(Duration.ofSeconds(productServiceTimeoutSec));
}
```

Fallback

```java
public Mono<ProductAggregate> getCompositeProduct(int productId, int delay, int faultPercent) {
    return Mono.zip(
        ...
        integration.getProduct(productId, delay, faultPercent)
           .onErrorReturn(CircuitBreakerOpenException.class, 
            getProductFallbackValue(productId)),
        ...
```

## Retry

One very important restriction on the use of the retry mechanism is that the services that it retries must be **idempotent**, that is, calling the service one or many times with the same request parameters gives the same result. 

- maxRetryAttempts: Number of retries before giving up, including the first call
- waitDuration: Wait time before the next retry attempt
- retryExceptions: A list of exceptions that shall trigger a retry

In this chapter, we will use the following values:

- maxRetryAttempts = 3: We will make a maximum of two retry attempts.
- waitDuration= 1000: We will wait one second between retries.
- retryExceptions = InternalServerError: We will only trigger retries on InternalServerError exceptions, that is, when HTTP requests respond with a 500 status code.

```java
@Retry(name = "product")
@CircuitBreaker(name = "product")
public Mono<Product> getProduct(int productId, int delay, int faultPercent) {


// Exceptions that are thrown by a method annotated with @Retry can be wrapped by the retry mechanism with a RetryExceptionWrapper exception. To be able to handle the actual exception that the method threw, for example, to apply a fallback method when CircuitBreakerOpenException is thrown, the caller needs to add logic that unwraps RetryExceptionWrapper exceptions and replaces them with the actual exception. 

public Mono<ProductAggregate> getCompositeProduct(int productId, int delay, int faultPercent) {
    return Mono.zip(
        ...
        integration.getProduct(productId, delay, faultPercent)
            .onErrorMap(RetryExceptionWrapper.class, retryException -> 
             retryException.getCause())
            .onErrorReturn(CircuitBreakerOpenException.class, 
             getProductFallbackValue(productId)),

```



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
docker-compose exec product-composite bash
docker-compose down
docker-compose ps

curl -k https://localhost:8443/actuator/health

docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/health
docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/
docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/health -qO - | jq -r .details.productCircuitBreaker.details.state

docker run --rm -it --network=my-network alpine wget product-composite:8080/actuator/retryevents -qO - | jq '.retryEvents[-2], .retryEvents[-1]'

circuitbreakerevents/product/STATE_TRANSITION
curl product-composite:8080/actuator/health
curl product-composite:8080/actuator/circuitbreakerevents/product/STATE_TRANSITION 
curl product-composite:8080/actuator/retryevents
```
##  Testing script

### Testing
https://localhost:8443/eureka/web 

Bad request below.

curl https://localhost:8443/product-composite/1?delay=3 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2OTE2NDksImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIwNzZkZDMyMC00NTBlLTQxYjYtYWYyOC02YTE1NTM3ZjBmNDAiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.VTXCI-X88iJ4fZCkKwlf1vVgz2Rmky_DkJK_PqLOx-mPRQPHxIX_-nFy5_XDcK7e8tlaf82qb1pxLOxwRJqm3RvTK8_RE8oRhRz-d1pEmbZWrgNky6PEpHl9PVruT3Kxaxe4kDa-Jv2Asfb92TGyvZY1-LIea9l1XNK10ze66XNH3JibqSmLGGkScpt6bYIWQKOSZhKKz18WWMJynEk3medsfV8COC-97xT7SyPUDLB4CDEEfd1HoVsr-NSCF8whyxCYlil69-QAk1HuSqQ8ZaYSHS0torO1cevTxBQPXVh5utfTk5NINSoJiCMcEb8ACgCpw33eZpCKr5LAqZ-xvg" 

Retry request below.
echo %TIME%
curl https://localhost:8443/product-composite/1?faultPercent=25 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtYWdudXMiLCJleHAiOjIxOTU2OTE2NDksImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIwNzZkZDMyMC00NTBlLTQxYjYtYWYyOC02YTE1NTM3ZjBmNDAiLCJjbGllbnRfaWQiOiJ3cml0ZXIiLCJzY29wZSI6WyJwcm9kdWN0OnJlYWQiLCJwcm9kdWN0OndyaXRlIl19.VTXCI-X88iJ4fZCkKwlf1vVgz2Rmky_DkJK_PqLOx-mPRQPHxIX_-nFy5_XDcK7e8tlaf82qb1pxLOxwRJqm3RvTK8_RE8oRhRz-d1pEmbZWrgNky6PEpHl9PVruT3Kxaxe4kDa-Jv2Asfb92TGyvZY1-LIea9l1XNK10ze66XNH3JibqSmLGGkScpt6bYIWQKOSZhKKz18WWMJynEk3medsfV8COC-97xT7SyPUDLB4CDEEfd1HoVsr-NSCF8whyxCYlil69-QAk1HuSqQ8ZaYSHS0torO1cevTxBQPXVh5utfTk5NINSoJiCMcEb8ACgCpw33eZpCKr5LAqZ-xvg" 
echo %TIME%



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


