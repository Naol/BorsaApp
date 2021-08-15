package encode.africa.borsawallet;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
//import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@SpringBootApplication
public class BorsaWalletApplication {


    public static void main(String[] args) {
        SpringApplication.run(BorsaWalletApplication.class, args);
//        BorsaStellar b= new BorsaStellar();
//        KeyPair pair = KeyPair.random();
//        System.out.println(new String(pair.getSecretSeed()));
//        System.out.println(pair.getAccountId());
    }

//    @EnableWebSecurity
//    @Configuration
//    class WebSecurityConfig extends WebSecurityConfigurerAdapter {
//
//        @Override
//        protected void configure(HttpSecurity http) throws Exception {
//            http.csrf().disable()
//                    .addFilterAfter(new JWTAuthorizationFilter(), UsernamePasswordAuthenticationFilter.class)
//                    .authorizeRequests()
//                    .antMatchers(HttpMethod.POST, "/user/login").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user").permitAll()
//                    .antMatchers(HttpMethod.GET, "/user").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/sendtoemail").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/getbalance").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/getbalancebyaid").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/getbalancebyid").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/issue").permitAll()
//                    .antMatchers(HttpMethod.POST, "/user/sendtophone").permitAll()
//                    .anyRequest().authenticated();
//        }
//    }
}
