package encode.africa.borsawallet.services;

import encode.africa.borsawallet.DAO.UserRepository;
import encode.africa.borsawallet.DAO.WaitlistRepository;
import encode.africa.borsawallet.models.TransactionStatus;
import encode.africa.borsawallet.models.User;
import encode.africa.borsawallet.models.WaitList;
import encode.africa.borsawallet.stellar.BorsaStellar;
import encode.africa.borsawallet.util.AES;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.stellar.sdk.*;
import java.util.List;
import java.util.Optional;

@Service
public class UserServiceClass {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private WaitlistServiceClass waitlistServiceClass;


    public void saveUser(User user){
        userRepository.save(user);

        WaitList w = waitlistServiceClass.getWaitListByReceiverId(user.getUsername());
        WaitList w1 = waitlistServiceClass.getWaitListByReceiverId(user.getPhoneNumber());

        if(w1 != null){
            System.out.println("Handle Waitlist transfer");
        }
        if (w != null){
            System.out.println("Handle Waitlist transfer");
        }

    }

    public List<User> getAllUsers(){
       return userRepository.findAll();
    }

    public User getUserByUsername(String username){
        return userRepository.findByUsername(username);
    }

    public Optional<User> getUserById(Long id){
        return userRepository.findById(id);
    }

    public User getUserByPhoneNumber(String pno){
        return userRepository.findByPhoneNumber(pno);
    }

    public User login(String username, String pass) {
        User user = userRepository.findByUsername(username);
        String pwd = DigestUtils.sha256Hex(pass + user.getsKey());
        if (user.getPass().equals(pwd)){
            return user;
        }
        return null;
    }


    private boolean sendETBT(KeyPair sender, KeyPair receiver, String message, double amount) {
        BorsaStellar bs = new BorsaStellar();
        return bs.sendETBT(sender,receiver, message, amount);
    }

    private String getBalance(KeyPair sender) {
        BorsaStellar bs = new BorsaStellar();
        return bs.getETBTBalance(sender);
    }

    private boolean issueETBTApp(long id, double amount){
        BorsaStellar bs = new BorsaStellar();
        return bs.issueETBT(getKeyPairFromId(id),amount);
    }

    KeyPair getKeyPairFromId(Long id){
        return KeyPair.fromSecretSeed(AES.decrypt(getUserById(id).get().getsKey(),"Dont TEll!"));
    }
    KeyPair getKeyPairFromUsername(String uname){
        return KeyPair.fromSecretSeed(AES.decrypt(getUserByUsername(uname).getsKey(),"Dont TEll!"));
    }
    KeyPair getKeyPairFromPhone(String phone){
        return KeyPair.fromSecretSeed(AES.decrypt(getUserByPhoneNumber(phone).getsKey(),"Dont TEll!"));
    }

    public boolean sendMoneyTotoUsername(Long from, String toUsername, String message, double amount) {
        if(checkIfEmailAddressExists(toUsername)){
            KeyPair sender = getKeyPairFromId(from);
            KeyPair receiver = getKeyPairFromUsername(toUsername);
            return sendETBT(sender,receiver, message, amount);
        }else {
            addToWaitList(from,toUsername, message, amount);
        }
        return false;
    }

    public boolean sendMoneyToPhone(Long from, String toPhone, String message, double amount) {

        if(checkIfPhoneNumberExists(toPhone)){
            KeyPair sender = getKeyPairFromId(from);
            KeyPair receiver = getKeyPairFromPhone(toPhone);
            return sendETBT(sender,receiver, message, amount);
        }else {
            addToWaitList( from,toPhone, message, amount);
        }
        return false;

    }

    void addToWaitList(Long from, String toPhone, String message, double amount){
        waitlistServiceClass.addWaitList(new WaitList(from, toPhone, message, amount, TransactionStatus.pending));
    }

    boolean checkIfEmailAddressExists(String toUsername){
        if (getUserByUsername(toUsername) != null)
            return true;
        System.out.println("Username doesnt exist");
        return false;
    }

    boolean checkIfPhoneNumberExists(String toPhone){
        if (getUserByPhoneNumber(toPhone) != null)
            return true;
        System.out.println("Phone num doesnt exist");
        return false;
    }


    public String getBalance(long from) {
        return getBalance(getKeyPairFromId(from));
    }

    public String getBalanceByAid(String key) {
        return getBalance(KeyPair.fromAccountId(key));
    }

    public String issueETBT(long id, double amount) {
        if (issueETBTApp(id,amount)) {
            return getBalance(getKeyPairFromId(id));
        }else{
            return "Error";
        }

    }
}
