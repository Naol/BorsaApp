//package encode.africa.borsawallet.services;
//
//import encode.africa.borsawallet.DAO.UserDAO;
//import encode.africa.borsawallet.models.User;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.stereotype.Service;
//
//@Service
//public class UserService {
//    private final UserDAO userDAO;
//
//    @Autowired
//    public UserService(@Qualifier("UserDAOImp") UserDAO userDAO) {
//        this.userDAO = userDAO;
//    }
//
//    public boolean saveUser(User student) {
//        userDAO.saveUser(student);
//        return false;
//    }
//
//}
