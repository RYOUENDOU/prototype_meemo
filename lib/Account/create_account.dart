import 'package:flutter/material.dart';
import 'package:meemo/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meemo/terms_of_Service.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<CreateAccount> {
  String? name;
  bool isVisible = false;

  void setName(String name) {
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    // デバイスの横幅を取得する
    double screenWidth = MediaQuery.of(context).size.width;
    //ローカライズクラスを取得
    final l10n = L10n.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Container(
          margin: EdgeInsets.all(screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [Text("姓名")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          filled: true,
                          hintText: '姓'),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          filled: true,
                          hintText: '名'),
                    ),
                  )
                ],
              ),
              const Row(
                children: [Text('せいめい')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          filled: true,
                          hintText: 'せい'),
                      onChanged: (text) {
                        setName((text));
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          filled: true,
                          hintText: 'めい'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [Text('メールアドレス')],
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.84,
                    child: const TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          hintText: 'メールアドレス'),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Text(
                    l10n.serviceConsent,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsOfService(),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 85, 189, 122),
                    fixedSize: const Size(double.maxFinite, 60),
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: Text(
                  l10n.create,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ));
  }
}
