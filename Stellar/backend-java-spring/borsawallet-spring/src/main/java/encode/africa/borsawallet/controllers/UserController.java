package encode.africa.borsawallet.controllers;

import encode.africa.borsawallet.models.User;
import encode.africa.borsawallet.services.UserServiceClass;
import encode.africa.borsawallet.util.AES;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Encoders;
import io.jsonwebtoken.security.Keys;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.web.bind.annotation.*;
import org.stellar.sdk.KeyPair;
import shadow.com.google.gson.Gson;

import javax.crypto.SecretKey;
import java.util.*;
import java.util.stream.Collectors;

@RequestMapping("/user")
@RestController
public class UserController {

    private final UserServiceClass userServiceClass;

    @Autowired
    public UserController(UserServiceClass userServiceClass) {
        this.userServiceClass = userServiceClass;
    }

    @GetMapping()
    public List<User> findAllUsers(){
        return userServiceClass.getAllUsers();
    }

    @PostMapping()
    public boolean addUser(@RequestBody User user){
        userServiceClass.saveUser(user);
        return true;
    }

    @PostMapping("/login")
    public String login(@RequestBody Map<String, Object> data){
        Gson gson = new Gson();
        User user = userServiceClass.login(data.get("username").toString(),
                data.get("pass").toString());
        if (user == null){
            return "0";
        }else{
            return gson.toJson(user);//getJWTToken(uname);
        }
    }

    @PostMapping("/sendtoemail")
    public boolean sendMoneyToUsername(@RequestBody Map<String, Object> data){
        return userServiceClass.sendMoneyTotoUsername(Long.parseLong(data.get("from").toString()),
                data.get("toUsername").toString(),data.get("message").toString(),
                Double.parseDouble(data.get("amount").toString()));
    }

    @PostMapping("/getbalancebyid")
    public String getBalance(@RequestBody Map<String, Object> data){
        return userServiceClass.getBalance(Long.parseLong(data.get("from").toString()));
    }

    @PostMapping("/getbalancebyaid")
    public String getBalanceByAid(@RequestBody Map<String, Object> data){
        return userServiceClass.getBalanceByAid(data.get("key").toString());
    }

    @PostMapping("/issue")
    public String issueETBT(@RequestBody Map<String, Object> data){
        return userServiceClass.issueETBT(Long.parseLong(data.get("id").toString()),
                Double.parseDouble(data.get("amount").toString()));
    }

    @PostMapping("/sendtophone")
    public boolean sendMoneyToPhone(@RequestBody Map<String, Object> data){
        return userServiceClass.sendMoneyToPhone(Long.parseLong(data.get("from").toString()),
                data.get("toPhone").toString(),data.get("message").toString(),
                Double.parseDouble(data.get("amount").toString()));
    }

    @GetMapping("/{username}")
    public User getUserByUsername(@PathVariable String username){
        return userServiceClass.getUserByUsername(username);
    }

    @GetMapping("/getpkey/{username}")
    public String getUserByPKey(@PathVariable String username){
        return KeyPair.fromSecretSeed(
                AES.decrypt(
                        userServiceClass.getUserByUsername(username).getsKey(),"Dont TEll!"))
                .getAccountId();
    }


//    @RequestMapping("hello")
//    public String helloWorld(@RequestParam(value="name", defaultValue="World") String name) {
//        return "Hello "+name+"!!";
//    }

//    private String getJWTToken(String username) {
//        String secretKey = "NAOL KEBEDE OLI AYANA ADO SHUNINAOL KEBEDE OLI AYANA ADO SHUNImySecretKeyddddddddddddddddddddddddddddddddddddddddddd";
//        List<GrantedAuthority> grantedAuthorities = AuthorityUtils
//                .commaSeparatedStringToAuthorityList("ROLE_USER");
//        SecretKey key = Keys.secretKeyFor(SignatureAlgorithm.HS256); //or HS384 or HS512
//        String base64Key = Encoders.BASE64.encode(key.getEncoded());
//
//        String token = Jwts
//                .builder()
//                .setId("Borsa")
//                .setSubject(username)
//                .claim("authorities",
//                        grantedAuthorities.stream()
//                                .map(GrantedAuthority::getAuthority)
//                                .collect(Collectors.toList()))
//                .setIssuedAt(new Date(System.currentTimeMillis()))
//                .setExpiration(new Date(System.currentTimeMillis() + 600000))
//                .signWith(SignatureAlgorithm.HS512,
//                        secretKey.getBytes()).compact();
//
//        return "Bearer " + token;
//    }

}
