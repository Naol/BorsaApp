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

@RequestMapping("/issuer")
@RestController
public class IssuerController {

    private final IssuerServiceClass issuerServiceClass;

    @Autowired
    public IssuerController(IssuerServiceClass issuerServiceClass) {
        this.issuerServiceClass = issuerServiceClass;
    }

    //issuers
    @GetMapping()
    public List<Issuer> findAllIssuers(){
        return issuerServiceClass.getAllIssuers();
    }

    @PostMapping()
    public boolean addIssuer(@RequestBody Issuer issuer){
        issuerServiceClass.saveIssuer(issuer);
        return true;
    }

    @GetMapping("/issuer/{username}")
    public Issuer getIssuerByUsername(@PathVariable String username){
        return issuerServiceClass.getIssuerByUsername(username);
    }

    @GetMapping("/issuer/{agentID}")
    public List<Issuer> getIssuerByAgentID(@PathVariable String agentID){
        return issuerServiceClass.getIssuersByAgentID(agentID);
    }

}
