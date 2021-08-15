package encode.africa.borsawallet.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;


//secret key and delegate usage rights
@Entity
public class PendingList {

    @Id
    Long id;
    Long sID, rID;
    String text;
    double amount;
    TransactionStatus status;

    public PendingList() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getsID() {
        return sID;
    }

    public void setsID(Long sID) {
        this.sID = sID;
    }

    public Long getrID() {
        return rID;
    }

    public void setrID(Long rID) {
        this.rID = rID;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status;
    }
}
