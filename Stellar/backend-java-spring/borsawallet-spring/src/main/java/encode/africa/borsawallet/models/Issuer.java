package encode.africa.borsawallet.models;

import javax.persistence.*;


//secret key and delegate usage rights
@Entity
public class Issuer {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;
    @Column(unique=true)
    String username;
    @Column(unique=true)
    String agentID;
    String fullName, pass;
    AccountStatus status;

    public Issuer( String username, String agentID,
                  String fullName, String pass, AccountStatus status) {
        this.username = username;
        this.agentID = agentID;
        this.fullName = fullName;
        this.pass = pass;
        this.status = status;
    }

    public Issuer() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAgentID() {
        return agentID;
    }

    public void setAgentID(String agentID) {
        this.agentID = agentID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public AccountStatus getStatus() {
        return status;
    }

    public void setStatus(AccountStatus status) {
        this.status = status;
    }
}
