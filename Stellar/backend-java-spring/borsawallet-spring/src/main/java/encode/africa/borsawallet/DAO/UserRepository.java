package encode.africa.borsawallet.DAO;

import encode.africa.borsawallet.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

    User findByUsername(String username);
    User findByPhoneNumber(String pno);

}
