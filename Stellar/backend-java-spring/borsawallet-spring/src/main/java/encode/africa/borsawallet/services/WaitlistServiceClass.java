package encode.africa.borsawallet.services;

import encode.africa.borsawallet.DAO.WaitlistRepository;
import encode.africa.borsawallet.models.TransactionStatus;
import encode.africa.borsawallet.models.WaitList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WaitlistServiceClass {

    @Autowired
    private WaitlistRepository waitlistRepository;
    public void addWaitList(WaitList waitList){
        waitlistRepository.save(waitList);
    }
    public List<WaitList> getAllWaitList(){
       return waitlistRepository.findAll();
    }
    public WaitList getWaitListBySenderId(Long id){
        return waitlistRepository.findBySenderId(id);
    }
    public WaitList getWaitListByReceiverId(String id){return waitlistRepository.findByReceiverId(id);}
    public List<WaitList> findByStatus(TransactionStatus status){
        return waitlistRepository.findByStatus(status);
    }


}
