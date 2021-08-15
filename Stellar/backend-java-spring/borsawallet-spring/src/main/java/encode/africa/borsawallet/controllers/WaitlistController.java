package encode.africa.borsawallet.controllers;

import encode.africa.borsawallet.models.Issuer;
import encode.africa.borsawallet.models.TransactionStatus;
import encode.africa.borsawallet.models.User;
import encode.africa.borsawallet.models.WaitList;
import encode.africa.borsawallet.services.IssuerServiceClass;
import encode.africa.borsawallet.services.UserServiceClass;
import encode.africa.borsawallet.services.WaitlistServiceClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequestMapping("/waitlist")
@RestController
public class WaitlistController {
    private final WaitlistServiceClass waitListServiceClass;

    @Autowired
    public WaitlistController(WaitlistServiceClass waitListServiceClass) {
        this.waitListServiceClass = waitListServiceClass;
    }

    @GetMapping()
    public List<WaitList> findAllWaitLists(){
        return waitListServiceClass.getAllWaitList();
    }

    @PostMapping()
    public boolean addWaitList(@RequestBody WaitList waitList){
        waitListServiceClass.addWaitList(waitList);
        return true;
    }

    @GetMapping("/receiver/{rId}")
    public WaitList getWaitListByrId(@PathVariable String rId){
        return waitListServiceClass.getWaitListByReceiverId(rId);
    }
    @GetMapping("/sender/{sId}")
    public WaitList getWaitListBysId(@PathVariable Long sId){
        return waitListServiceClass.getWaitListBySenderId(sId);
    }

    @GetMapping("/{agentID}")
    public List<WaitList> getWaitListByTransactionStat(@PathVariable TransactionStatus status){
        return waitListServiceClass.findByStatus(status);
    }


}
