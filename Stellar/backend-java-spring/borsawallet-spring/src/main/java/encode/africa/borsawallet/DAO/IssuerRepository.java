package encode.africa.borsawallet.DAO;

import encode.africa.borsawallet.models.Issuer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface IssuerRepository extends JpaRepository<Issuer, Long> {
    List<Issuer> findByAgentID(String agentId);
    Issuer findByUsername(String username);
}
