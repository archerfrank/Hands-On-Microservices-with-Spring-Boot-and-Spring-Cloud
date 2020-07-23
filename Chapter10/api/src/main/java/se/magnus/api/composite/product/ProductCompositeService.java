package se.magnus.api.composite.product;


import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;


public interface ProductCompositeService {

    /**
     * Sample usage:
     *
     * curl -X POST $HOST:$PORT/product-composite \
     *   -H "Content-Type: application/json" --data \
     *   '{"productId":123,"name":"product 123","weight":123}'
     *
     * @param body
     */

    @PostMapping(
        value    = "/product-composite",
        consumes = "application/json")
    void createCompositeProduct(@RequestBody ProductAggregate body);

    /**
     * Sample usage: curl $HOST:$PORT/product-composite/1
     *
     * @param productId
     * @return the composite product info, if found, else null
     */

    @GetMapping(
        value    = "/product-composite/{productId}",
        produces = "application/json")
    ProductAggregate getCompositeProduct(@PathVariable int productId);


    /**
     * Sample usage:
     *
     * curl -X DELETE $HOST:$PORT/product-composite/1
     *
     * @param productId
     */
  
    @DeleteMapping(value = "/product-composite/{productId}")
    void deleteCompositeProduct(@PathVariable int productId);
}