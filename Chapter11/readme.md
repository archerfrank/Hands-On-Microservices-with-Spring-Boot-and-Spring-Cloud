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

change both gateway and product-composite between 
```
local auth server
#spring.security.oauth2.resourceserver.jwt.jwk-set-uri: http://${app.auth-server}:9999/.well-known/jwks.json

open id server
spring.security.oauth2.resourceserver.jwt.issuer-uri: https://archerfrank.us.auth0.com/

```


## Build script
```
SET COMPOSE_FILE=docker-compose.yml
SET COMPOSE_FILE=docker-compose-partitions.yml
SET COMPOSE_FILE=docker-compose-kafka.yml
SET COMPOSE_FILE=docker-compose-openid.yml

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

## Use Open ID Auth

1. Open the URL, https://auth0.com, in your browser. I used github to login.

2. Click on the SIGN UP button: 

    * Sign up with an account of your choice.

    * After a successful sign-up, you will be asked to create a tenant domain.
    Enter the name of the tenant of your choice, in my case: dev-ml.eu.auth0.com.

    * Fill in information about your account as requested.

3. Following sign-up, you will be directed to your dashboard. Select the Applications tab (on the left) to see the default client application that was created for you during the sign-up process.

4. Click on the Default App to configure it:

   * Copy the Client ID and Client Secret; you will need them later on.
        tgrQGMAlGzh45ZQ91qtsQEDktolC1EEB
        alwWwhTST6kUZboudysvNvTlBi3glLlZVj3yRXziDVWfMV_kO79-gHT6rr6cmIBJ
   * As Application Type, select Machine to Machine.

   * As Token Endpoint Authentication Method, select POST.

   * Enter http://my.redirect.uri as the allowed callback URL.

   * Click on Show Advanced Settings, go to the Grant Types tab, deselect Client Credentials, and select the Password box.

   * Click on SAVE CHANGES.

5. Now define authorizations for our API:

   * Click on the APIs tab (on the left) and click on the + CREATE API button.

   * Name the API product-composite, give it the identifier https://localhost:8443/product-composite, and click on the CREATE button.

   * Click on the Permissions tab and create two permissions (that is, OAuth scopes) for product:read and product:write.

6. Next, create a user:
Click on the Users & Roles and -> Users tab (on the left) and then on the + CREATE YOUR FIRST USER button.
   * Enter an email and password of your preference and click on the SAVE button.
    archerfrank@163.com wf!83xxxx
   * Look for a verification mail from Auth0 in the Inbox for the email address you supplied.

7. Finally, validate your Default Directory setting, used for the password grant flow:
   * Click on your tenant profile in the upper-right corner and select Settings.
   * In the tab named General, scroll down to the field named Default Directory and verify that it contains  the Username-Password-Authentication value. If not, update the field and save the change.
  
8. That's it! Note that both the default app and the API get a client ID and secret. We will use the client ID and secret for the default app; that is, the OAuth client.

```
curl -i https://archerfrank.us.auth0.com/.well-known/openid-configration

// get the token
curl -k -X POST https://archerfrank.us.auth0.com/oauth/token -H "Content-Type: application/json" -d @data2.json

eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkIxbmczeFJKallzWWptOEhkZjEwMiJ9.eyJpc3MiOiJodHRwczovL2FyY2hlcmZyYW5rLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ZjFhZGQxNzI4ZGRiYTAwMzc0MzljZTEiLCJhdWQiOlsiaHR0cHM6Ly9sb2NhbGhvc3Q6ODQ0My9wcm9kdWN0LWNvbXBvc2l0ZSIsImh0dHBzOi8vYXJjaGVyZnJhbmsudXMuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU5NTYwMzg2MiwiZXhwIjoxNTk1NjkwMjYyLCJhenAiOiJ0Z3JRR01BbEd6aDQ1WlE5MXF0c1FFRGt0b2xDMUVFQiIsInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2R1Y3Q6d3JpdGUiLCJndHkiOiJwYXNzd29yZCJ9.WANufEYHetKUrPKEhOcI490a9x8sSvkQfm4X7ViRdkOpCXryJv-5KJyVo8VN3zHSiGWzhgeZasPIGiTS7b94BX6jc6ff479OTL9_k6G6z0qSFZ8uAtphaTu-jRJ4ZyLGvuthKtX3tBXTckAaiuRD709NdTZ46Wed6ArOFgGCRM_A3ohP13Zj7AyJhu4VneaxovRzw9qvvsvUw4c5r28OztErzpg89RV3q6ZeHI_hF7JdRUvTEFF3mAAMc3pP-5niPSsRYOMRwsN66vjFsDEvwougT6IQ7jeIWqUMgMNFOX2j594pOqGS_5CZ2NR6B7x4xbr_XWCP7mUPXACpm3rMnA

curl -k -i https://localhost:8443/product-composite/1

# Test to visit the read url

curl https://localhost:8443/product-composite/1 -i -k -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkIxbmczeFJKallzWWptOEhkZjEwMiJ9.eyJpc3MiOiJodHRwczovL2FyY2hlcmZyYW5rLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ZjFhZGQxNzI4ZGRiYTAwMzc0MzljZTEiLCJhdWQiOlsiaHR0cHM6Ly9sb2NhbGhvc3Q6ODQ0My9wcm9kdWN0LWNvbXBvc2l0ZSIsImh0dHBzOi8vYXJjaGVyZnJhbmsudXMuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU5NTYwNjY2MCwiZXhwIjoxNTk1NjkzMDYwLCJhenAiOiJ0Z3JRR01BbEd6aDQ1WlE5MXF0c1FFRGt0b2xDMUVFQiIsInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2R1Y3Q6cmVhZCBwcm9kdWN0OndyaXRlIn0.nyMek6KaJNyU5fq6gS3xCjlQ0LRa-vPd905DwIiTM6myYRm5GjrCQ4S4zW_nQoGw2sbdQITkIq5_9R6ABUKMX6yIntxDJeZj8N8kqrlvJgVuIMezvMwj7kZBJ2tBId3-9TyGXml0CMQ_MjKOZwWSusfSND3tvxDahoWSmxpdCrkNcfJkpPNPFEYOwKSAVK_rznBRUNlEdv_H8K85kA6a0KTVlxCfmKpnBZ2f9TKb0IXn9iSx2er6W6ZrbPetJmoSxsV6vps5atdZqRheNzVeP8XxBOBDq2xsFfta3scrjyqsYP4IQOoaPHkRZsTMCoy7BrLYUTWFLAGacmUXv1IdGQ" 

# Test to visit the write url
curl -k -i -X POST https://localhost:8443/product-composite -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkIxbmczeFJKallzWWptOEhkZjEwMiJ9.eyJpc3MiOiJodHRwczovL2FyY2hlcmZyYW5rLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ZjFhZGQxNzI4ZGRiYTAwMzc0MzljZTEiLCJhdWQiOlsiaHR0cHM6Ly9sb2NhbGhvc3Q6ODQ0My9wcm9kdWN0LWNvbXBvc2l0ZSIsImh0dHBzOi8vYXJjaGVyZnJhbmsudXMuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU5NTYwMzg2MiwiZXhwIjoxNTk1NjkwMjYyLCJhenAiOiJ0Z3JRR01BbEd6aDQ1WlE5MXF0c1FFRGt0b2xDMUVFQiIsInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2R1Y3Q6d3JpdGUiLCJndHkiOiJwYXNzd29yZCJ9.WANufEYHetKUrPKEhOcI490a9x8sSvkQfm4X7ViRdkOpCXryJv-5KJyVo8VN3zHSiGWzhgeZasPIGiTS7b94BX6jc6ff479OTL9_k6G6z0qSFZ8uAtphaTu-jRJ4ZyLGvuthKtX3tBXTckAaiuRD709NdTZ46Wed6ArOFgGCRM_A3ohP13Zj7AyJhu4VneaxovRzw9qvvsvUw4c5r28OztErzpg89RV3q6ZeHI_hF7JdRUvTEFF3mAAMc3pP-5niPSsRYOMRwsN66vjFsDEvwougT6IQ7jeIWqUMgMNFOX2j594pOqGS_5CZ2NR6B7x4xbr_XWCP7mUPXACpm3rMnA"
```


#### implicit grant flow

```
https://archerfrank.us.auth0.com/authorize?response_type=token&scope=openid email product:read product:write&client_id=tgrQGMAlGzh45ZQ91qtsQEDktolC1EEB&state=98421&&nonce=jxdlsjfi0fa&redirect_uri=https://localhost:8443/product-composite/1&audience=https://localhost:8443/product-composite

https://localhost:8443/product-composite/1#access_token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkIxbmczeFJKallzWWptOEhkZjEwMiJ9.eyJpc3MiOiJodHRwczovL2FyY2hlcmZyYW5rLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ZjFhZGQxNzI4ZGRiYTAwMzc0MzljZTEiLCJhdWQiOlsiaHR0cHM6Ly9sb2NhbGhvc3Q6ODQ0My9wcm9kdWN0LWNvbXBvc2l0ZSIsImh0dHBzOi8vYXJjaGVyZnJhbmsudXMuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTU5NTYwNTgyOCwiZXhwIjoxNTk1NjEzMDI4LCJhenAiOiJ0Z3JRR01BbEd6aDQ1WlE5MXF0c1FFRGt0b2xDMUVFQiIsInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2R1Y3Q6cmVhZCBwcm9kdWN0OndyaXRlIn0.C1UfUQISEryw3y30qX6cUm_DfJb5RG21hcuvSBTeJaVA3glw7iYUwgUC9rkUnl_jQ0o1iroCuCXVj_M3XiRTNW9tKkeC2bxhs24aglUn2KG03xUsPNc9ZEQr69bcMfcYEXtLiCviIomR3_bPrsZA2cIb3xuxcUVD3OIKwdc46Law-uBa_-Mvvh97DW3B1HwlOwBjggesXouQZDfdcKYernYRNjFZI-hV6Pq6opJog2atZ22F7_YU-UlU1Dk9zislEEglnepF1GadPB9MnTHJIxgD713cdT4rEGOuvDZ49hSmXotIdEqEyRF6knGmce4llbCi1JyJroDh0VJsGJYYBA&scope=openid%20email%20product%3Aread%20product%3Awrite&expires_in=7200&token_type=Bearer&state=98421


```

#### code grant flow
```
https://archerfrank.us.auth0.com/authorize?audience=https://localhost:8443/product-composite&scope=openid email product:read product:write&response_type=code&client_id=tgrQGMAlGzh45ZQ91qtsQEDktolC1EEB&redirect_uri=https://localhost:8443/product-composite/1&state=845361

Copy url https://localhost:8443/product-composite/1?code=o4FauTUVAX_cRv1C&state=845361

curl -k https://reader:secret@localhost:8443/oauth/token -d grant_type=authorization_code -d client_id=reader -d redirect_uri=http://my.redirect.uri -d code=o4FauTUVAX_cRv1C

curl --request POST --url 'https://archerfrank.us.auth0.com/oauth/token' \
--header 'content-type: application/json' \
--data ''

curl -X POST https://archerfrank.us.auth0.com/oauth/token -H "Content-Type: application/json" -d @data3.json


```

