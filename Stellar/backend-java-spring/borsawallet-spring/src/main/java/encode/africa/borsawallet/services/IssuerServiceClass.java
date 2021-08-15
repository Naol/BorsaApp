package encode.africa.borsawallet.services;

import encode.africa.borsawallet.DAO.IssuerRepository;
import encode.africa.borsawallet.DAO.UserRepository;
import encode.africa.borsawallet.models.Issuer;
import encode.africa.borsawallet.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IssuerServiceClass {

    @Autowired
    private IssuerRepository issuerRepository;

    public void saveIssuer(Issuer issuer){
        issuerRepository.save(issuer);
    }

    public List<Issuer> getAllIssuers(){
       return issuerRepository.findAll();
    }

    public Issuer getIssuerByUsername(String username){
        return issuerRepository.findByUsername(username);
    }
    public List<Issuer> getIssuersByAgentID(String agentId){
        return issuerRepository.findByAgentID(agentId);
    }


}
