import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meemo/view/certification.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? phoneNumber;
  bool isVisible = false;

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    //ローカライズクラスを取得
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        l10n.phoneText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidateText.phoneNumber,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.5)),
                          filled: true,
                          hintText: '09012345678'),
                      onChanged: (text) {
                        // ここで監視するのではなく、
                        setPhoneNumber(text);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 85, 189, 122),
                        fixedSize: Size(double.maxFinite, 60),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // ここでバリデーション
                        if (phoneNumber == '' || phoneNumber == null) {
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Certification(),
                          ),
                        );
                      },
                      child: Text(l10n.certification,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class ValidateText {
  static String? phoneNumber(String? value) {
    if (value != null) {
      String pattern = r'^[0-9]';
      RegExp regExp = RegExp(pattern);
      if (value == '') {
        return '電話番号を入力してください';
      }
      if (!regExp.hasMatch(value)) {
        return '電話番号は数字のみを入力してください';
      }
    }
    return null;
  }
}
