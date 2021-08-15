package encode.africa.borsawallet.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import encode.africa.borsawallet.stellar.BorsaStellar;
import encode.africa.borsawallet.util.AES;
import org.apache.commons.codec.digest.DigestUtils;

import javax.persistence.*;
import java.util.Date;


//secret key and delegate usage rights

@Entity
public class User {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    Long id;
    @Column(unique=true)
    String username;
    @Column(unique=true)
    String phoneNumber;
    @Column(unique=true)
    String sKey;

    String firstName, fatherName, gFatherName, pass;
    Date DOB, lastActivity;
    AccountStatus status;
    public User(@JsonProperty("name") String firstName,
                @JsonProperty("fname") String fatherName,
                @JsonProperty("gfname") String gFatherName,
                @JsonProperty("username")String username,
                @JsonProperty("pass") String pass,
                @JsonProperty("DOB") Date DOB,
                @JsonProperty("phno")String phoneNumber) {
        this.firstName = firstName;
        this.fatherName = fatherName;
        this.gFatherName = gFatherName;
        this.username = username;
        this.DOB = DOB;
        this.phoneNumber = phoneNumber;
        this.status = AccountStatus.active;
        this.sKey =  AES.encrypt(new String(BorsaStellar.createAccount().getSecretSeed()),"Dont TEll!");

        this.pass = DigestUtils.sha256Hex(pass + this.sKey);
    }

    public User() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    public String getgFatherName() {
        return gFatherName;
    }

    public void setgFatherName(String gFatherName) {
        this.gFatherName = gFatherName;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public Date getDOB() {
        return DOB;
    }

    public void setDOB(Date DOB) {
        this.DOB = DOB;
    }

    public AccountStatus getStatus() {
        return status;
    }

    public void setStatus(AccountStatus status) {
        this.status = status;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getsKey() {
        return sKey;
    }

    public void setsKey(String sKey) {
        this.sKey = sKey;
    }

    public Date getLastActivity() {
        return lastActivity;
    }

    public void setLastActivity(Date lastActivity) {
        this.lastActivity = lastActivity;
    }

}
