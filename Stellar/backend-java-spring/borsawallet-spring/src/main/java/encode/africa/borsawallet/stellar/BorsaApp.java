package encode.africa.borsawallet.stellar;

import encode.africa.borsawallet.models.User;
import encode.africa.borsawallet.util.AES;

import java.util.Date;
import java.util.Optional;

public class BorsaApp {

    // NO KYC PROCESS FOR NOW
    // public boolean KYC(User user){}
    private String secret = "Stellar";
    // username, phoneNo, password, FN/FN/GFN, (KEYPAIR from BORSASTELLAR/encrypted), DOB, amount
    public void createUser(String username, String pass, String name, String fName, String gfName,
                                  Date DOB, String phoneNo, double amount){
//        User user = new User(name,fName,gfName,username,pass,DOB,amount,phoneNo);
//        if (!userExists(user)){
//            // create user obj
//            user.setStatus(AccountStatus.active);
//            KeyPair keys = BorsaStellar.createAccount();
//            UserKeys ukeys = new UserKeys(username, phoneNo, encrypt(keys.getSecretSeed().toString()));
//            ur.save(user);
//            uk.save(ukeys);
//        }else {
//            throw new RuntimeException("User already exists");
//        }
    }



    public void login(String username, String pass){

    }

    public void sendETBT(){
        // get sender keys from user keys
        // get reciever keys
        // use the BoresaStellar to transfer currency
    }

    public double getBalance(){
        /*  1. Get user data and fetch keys from user Keys
            2. getBalance form BorsaStellar Class
        */
        return 0;
    }

    public void offRamp(){
        /*  1. Get user data and fetch keys from user Keys
            2. Burn tokens form BorsaStellar Class
        */
    }

}
