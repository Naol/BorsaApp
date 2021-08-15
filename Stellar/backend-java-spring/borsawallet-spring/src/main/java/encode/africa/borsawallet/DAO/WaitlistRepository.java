package encode.africa.borsawallet.DAO;

import encode.africa.borsawallet.models.Issuer;
import encode.africa.borsawallet.models.TransactionStatus;
import encode.africa.borsawallet.models.WaitList;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WaitlistRepository extends JpaRepository<WaitList, Long> {
    WaitList findBySenderId(Long senderId);
    WaitList findByReceiverId(String receiverId);
    List<WaitList> findByStatus(TransactionStatus transactionStatus);
}
