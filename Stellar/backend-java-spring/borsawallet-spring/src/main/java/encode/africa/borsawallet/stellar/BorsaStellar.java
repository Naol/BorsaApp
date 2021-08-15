package encode.africa.borsawallet.stellar;

import org.stellar.sdk.*;
import org.stellar.sdk.responses.AccountResponse;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class BorsaStellar {

    Server server = new Server("https://horizon-testnet.stellar.org");

    public static String SECRET_KEY_ISSUER,SECRET_KEY_DISTRIBUTOR;
    KeyPair issuingKeys, distributorKeys;
    Asset birrToken;

    public BorsaStellar(){
        initKeys();
//        System.out.println(issueTokenToDistributor());
//        KeyPair rand = KeyPair.fromSecretSeed("SBXCXHD3HEMLS6FVLYYFFIUXH2N7D35JDSIHUH3LI4OVL23663M3KDFN");
//        sendETBT(distributorKeys, rand, "Hello from naol",100 );
//        System.out.println(getETBTBalance(rand));
//        KeyPair test = KeyPair.fromAccountId("GCZANGBA5YHTNYVVV4C3U252E2B6P6F5T3U6MM63WBSBZATAQI3EBTQ4").;
//        System.out.println(test.getAccountId());

    }

    private void initKeys() {
        SECRET_KEY_ISSUER = getKeyFromFile("file.secret");
        SECRET_KEY_DISTRIBUTOR = getKeyFromFile("file2.secret");
        issuingKeys = KeyPair.fromSecretSeed(SECRET_KEY_ISSUER);
        distributorKeys = KeyPair.fromSecretSeed(SECRET_KEY_DISTRIBUTOR);
        System.out.println("ETBT issuance is " + issueTokenToDistributor());
    }

    private boolean issueTokenToDistributor() {
        birrToken = Asset.createNonNativeAsset("ETBT", issuingKeys.getAccountId());
        return changeDistributorTrustOp() && sendPaymentToActivateETBT();
    }
        private boolean changeDistributorTrustOp() {
        AccountResponse receiving = null;
        try {
            receiving = server.accounts().account(distributorKeys.getAccountId());
        } catch (IOException e) {
            e.printStackTrace();
        }
            try {
                return allowToAcceptETBT(receiving, distributorKeys);
            } catch (AccountRequiresMemoException | IOException e) {
                e.printStackTrace();
            }
            return false;
        }
        private boolean sendPaymentToActivateETBT() {
            AccountResponse issuing = null;
            try {
                issuing = server.accounts().account(issuingKeys.getAccountId());
            } catch (IOException e) {
                e.printStackTrace();
            }
            Transaction sendAstroDollars = transact(issuing, new PaymentOperation.Builder(distributorKeys.getAccountId(),
                    birrToken, "1000000").build(),"");
            setAuthorization(distributorKeys.getAccountId(), AccountFlag.AUTH_REQUIRED_FLAG);
            sendAstroDollars.sign(issuingKeys);
            try {
                return server.submitTransaction(sendAstroDollars).isSuccess();
            } catch (IOException | AccountRequiresMemoException e) {
                e.printStackTrace();
            }
            return false;
        }

    public Transaction transact(AccountResponse address, Operation operation, String memo){
        return new Transaction.Builder(address, Network.TESTNET)
                .addOperation(operation).setBaseFee(100).
                setTimeout(Transaction.Builder.TIMEOUT_INFINITE).addMemo(Memo.text(memo)).build();
    }

    public boolean setAuthorization(String accountID, AccountFlag flag){
        AccountResponse sourceAccount = null;
        try {
            sourceAccount = server.accounts().account(accountID);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Transaction setAuthorization = transact(sourceAccount,
                new SetOptionsOperation.Builder().setSetFlags(flag.getValue()).build(),"");
        setAuthorization.sign(distributorKeys);
        try {
            return server.submitTransaction(setAuthorization).isSuccess();
        } catch (IOException | AccountRequiresMemoException e) {
            e.printStackTrace();
        }
        System.out.println("Authorization Failed");
        return false;
    }


    private boolean userExists(KeyPair receiver) {
        try {
            server.accounts().account(receiver.getAccountId());
            return true;
        } catch (IOException e) {
            System.out.println("Receiver doesnt exist");
            e.printStackTrace();
        }
        return false;
    }

    public boolean issueETBT(KeyPair receiver, double amount){
        return sendETBT(distributorKeys, receiver, "Issueance of ETBT", amount);
    }

    public boolean sendETBT(KeyPair sender, KeyPair receiver, String message, double amount){

        if(getETBTBalance(sender) == null || Double.parseDouble(getETBTBalance(sender)) < amount) {
            System.out.println("Sender Balance" + getETBTBalance(sender));
            return false;
        }
        if (userExists(sender)) {
            AccountResponse sourceAccount = null;
            AccountResponse destinationAccount = null;
            try {
                sourceAccount = server.accounts().account(sender.getAccountId());
                destinationAccount = server.accounts().account(receiver.getAccountId());
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                allowToAcceptETBT(destinationAccount, receiver);
            } catch (AccountRequiresMemoException e) {
                e.printStackTrace();
            } catch (IOException e) {
                System.out.println("Didnt change trust");
                e.printStackTrace();
            }
            Transaction transaction = transact(sourceAccount,
                    new PaymentOperation.Builder(receiver.getAccountId(), birrToken, String.valueOf(amount)).build(), message);
            transaction.sign(sender);
            try {
                server.submitTransaction(transaction);
            } catch (Exception e) {
                System.out.println("Something went wrong!");
                System.out.println(e.getMessage());
            }
            System.out.println("Success " + sender.getAccountId() + " "+new String(sender.getSecretSeed()));
            System.out.println("Destination " + receiver.getAccountId() + " "+new String(receiver.getSecretSeed()));
            return true;

        }
        System.out.println("No Success");
        return false;
    }

    private boolean allowToAcceptETBT(AccountResponse destinationAccount, KeyPair keys) throws AccountRequiresMemoException, IOException {

        Transaction allowETBT = transact(destinationAccount,
                new ChangeTrustOperation.Builder(birrToken, "10000000000").build(),"");
        allowETBT.sign(keys);
        return server.submitTransaction(allowETBT).isSuccess();

    }


    public String getETBTBalance(KeyPair keys){
        try {
            System.out.println(keys.getAccountId());
            AccountResponse account = server.accounts().account(keys.getAccountId());
            for (AccountResponse.Balance x:account.getBalances()) {
                System.out.println(x.getBalance() + " " + x.getAssetCode());
                if (x.getAssetCode().equals("ETBT") && x.getAssetIssuer().equals(issuingKeys.getAccountId()) ){
                    return x.getBalance();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static KeyPair createAccount(){
        KeyPair pair = KeyPair.random();
        getTestFundsFromFriendBot(pair);
        trustETBT(pair);
        return pair;
    }

    private static void trustETBT(KeyPair pair) {
        BorsaStellar bs = new BorsaStellar();
        AccountResponse dAccount = null;
        try {
            dAccount = new Server("https://horizon-testnet.stellar.org").accounts().account(pair.getAccountId());
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            bs.allowToAcceptETBT(dAccount,pair);
        } catch (AccountRequiresMemoException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void getKeypairTransactions(KeyPair keyPair){

    }

    private static void getTestFundsFromFriendBot(KeyPair pair) {
        String friendbotUrl = String.format(
                "https://friendbot.stellar.org/?addr=%s",
                pair.getAccountId());
        InputStream response = null;
        try {
            response = new URL(friendbotUrl).openStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
        assert response != null;
        String body = new Scanner(response, StandardCharsets.UTF_8).useDelimiter("\\A").next();
//        System.out.println("SUCCESS! You have a new account :)\n" + body);
    }

    public boolean burnETBT(KeyPair sender, double amount, String memo){
        if (memo.isBlank())
            memo = "Burned";
        return sendETBT(sender, distributorKeys, memo, amount);

    }

    private String getKeyFromFile(String filename) {
        try {
            File myObj = new File(filename);
            Scanner myReader = new Scanner(myObj);
            StringBuilder data = new StringBuilder();
            while (myReader.hasNextLine()) {
                data.append(myReader.nextLine());
            }
            myReader.close();
            return data.toString().trim();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        return null;
    }

}
