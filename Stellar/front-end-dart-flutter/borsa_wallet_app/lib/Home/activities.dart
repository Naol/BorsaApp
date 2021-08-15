import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Widget loading = CircularProgressIndicator();

  String id = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    getPaymentTransactions();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff455A64),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: showList(),
    );
  }

  showList() {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              loading,
              FutureBuilder(
                future: getRawList(),
                builder: (context, AsyncSnapshot<http.Response> projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Text("sdf");
                  }
                  loading = Container();
                  print(json.decode(projectSnap.data.body)['_embedded']
                      ['records']);
                  List<Transaction> list = processJson(json
                      .decode(projectSnap.data.body)['_embedded']['records']);
                  return ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      Transaction project = list[index];
                      String pass = project._created_at
                          .substring(0, project._created_at.length - 4);
                      return Card(
                          child: ListTile(
                              trailing: Text(
                                  pass.substring(0, pass.length - 6) +
                                      "\n" +
                                      pass.substring(
                                          pass.length - 6, pass.length),
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold)),
                              title: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: getSender(project._from) +
                                      " " +
                                      project._amount.substring(
                                          0, project._amount.length - 5),
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: " ETB",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ])),
                              subtitle: Text(
                                  identify(project._from) + " " + project._to),
                              leading: Icon(getSenderIcon(project._from))));
                    },
                  );
                },
              ),
            ],
          )),
    );
  }

  Future<http.Response> getRawList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    id = sp.getString("pkey");
    return http.get(Uri.parse('https://horizon-testnet.stellar.org/accounts/'
        '$id/payments?order=desc'));
  }

//  Future<List<Transaction>> getPaymentTransactions() async {
//    List<Transaction> transactions = [];
//    getRawList().then((value) {
//      List<dynamic> list = json.decode(value.body)['_embedded']['records'];
//      list.forEach((element) {
//        print(element);
//        transactions.add(new Transaction(
//          element["id"],
//          element["paging_token"],
//          element["source_account"],
//          element["type"],
//          element["created_at"],
//          element["transaction_hash"],
//          element["asset_type"],
//          element["asset_code"],
//          element["asset_issuer"],
//          element["from"],
//          element["to"],
//          element["amount"],
//          element["transaction_successful"],
//        ));
//      });
//    });
//    return transactions;
//  }

  String getSender(String project) {
    if (project == id) return "Sent";
    return "Received";
  }

  getSenderIcon(String project) {
    if (project == id) return Icons.call_made;
    return Icons.call_received;
  }

  List<Transaction> processJson(decode) {
    List<dynamic> list = decode;
    List<Transaction> transactions = [];
    list.forEach((element) {
      if (element['type'] == "payment") {
        transactions.add(new Transaction(
          element["id"],
          element["paging_token"],
          element["source_account"],
          element["type"],
          element["created_at"],
          element["transaction_hash"],
          element["asset_type"],
          element["asset_code"],
          element["asset_issuer"],
          element["from"],
          element["to"],
          element["amount"],
          element["transaction_successful"],
        ));
      }
    });
    return transactions;
  }

  String identify(String project) {
    if (project == id) return "to";
    return "from";
  }

  String getUsernameFromPKey(String from, String to) {
    if (from == id) {
      return to;
    } else {
      return from;
    }
  }

  String checkusername(String key) {}
}

class Transaction {
  String _id,
      _paging_token,
      _source_account,
      _type,
      _created_at,
      _transaction_hash,
      _asset_type,
      _asset_code,
      _asset_issuer,
      _from,
      _to,
      _amount;
  bool _transaction_successful;

  Transaction(
      this._id,
      this._paging_token,
      this._source_account,
      this._type,
      this._created_at,
      this._transaction_hash,
      this._asset_type,
      this._asset_code,
      this._asset_issuer,
      this._from,
      this._to,
      this._amount,
      this._transaction_successful);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get paging_token => _paging_token;

  set paging_token(value) {
    _paging_token = value;
  }

  get source_account => _source_account;

  set source_account(value) {
    _source_account = value;
  }

  get type => _type;

  set type(value) {
    _type = value;
  }

  get created_at => _created_at;

  set created_at(value) {
    _created_at = value;
  }

  get transaction_hash => _transaction_hash;

  set transaction_hash(value) {
    _transaction_hash = value;
  }

  get asset_type => _asset_type;

  set asset_type(value) {
    _asset_type = value;
  }

  get asset_code => _asset_code;

  set asset_code(value) {
    _asset_code = value;
  }

  get asset_issuer => _asset_issuer;

  set asset_issuer(value) {
    _asset_issuer = value;
  }

  get from => _from;

  set from(value) {
    _from = value;
  }

  get to => _to;

  set to(value) {
    _to = value;
  }

  get amount => _amount;

  set amount(value) {
    _amount = value;
  }

  bool get transaction_successful => _transaction_successful;

  set transaction_successful(bool value) {
    _transaction_successful = value;
  }

  @override
  String toString() {
    return 'Transaction{_id: $_id, _paging_token: $_paging_token, _source_account: $_source_account, _type: $_type, _created_at: $_created_at, _transaction_hash: $_transaction_hash, _asset_type: $_asset_type, _asset_code: $_asset_code, _asset_issuer: $_asset_issuer, _from: $_from, _to: $_to, _amount: $_amount, _transaction_successful: $_transaction_successful}';
  }
}
