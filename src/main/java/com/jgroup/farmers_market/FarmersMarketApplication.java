package com.jgroup.farmers_market;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class FarmersMarketApplication {

    public static void main(String[] args) {
        SpringApplication.run(FarmersMarketApplication.class, args);
    }

}
