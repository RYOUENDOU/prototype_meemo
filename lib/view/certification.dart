import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meemo/view/home.dart';

class Certification extends StatefulWidget {
  const Certification({super.key});
  @override
  State createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  int? certificationCode;
  bool isVisible = false;

  void setCertificationCode(int certificationCode) {
    this.certificationCode = certificationCode;
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
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.certificationCode,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("{引き継いだ電話番号}にSNSで認証番号を送信しました"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1)
                    ],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1)
                    ],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1)
                    ],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1)
                    ],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5)),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  // 前の画面で引き継いだ電話番号へcoginitoに送信するロジック呼び出し

                  //仮でMapに遷移
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text(
                  "認証番号を送信",
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue),
                ))
          ],
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       const Padding(
      //         padding: EdgeInsets.all(16.0),
      //       ),
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           l10n.certificationCode,
      //           style: const TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       Padding(
      //           padding: const EdgeInsets.all(16.0),
      //           child: Column(
      //             children: [
      //               TextFormField(
      //                 maxLength: 1,
      //                 keyboardType: TextInputType.number,
      //                 autovalidateMode: AutovalidateMode.onUserInteraction,
      //                 validator: ValidateText.certificationCode,
      //                 decoration: const InputDecoration(filled: true),
      //                 onChanged: (text) {
      //                   setCertificationCode(int.parse(text));
      //                 },
      //               ),
      //               TextFormField(
      //                 maxLength: 1,
      //                 keyboardType: TextInputType.number,
      //                 autovalidateMode: AutovalidateMode.onUserInteraction,
      //                 validator: ValidateText.certificationCode,
      //                 decoration: const InputDecoration(filled: true),
      //                 onChanged: (text) {
      //                   setCertificationCode(int.parse(text));
      //                 },
      //               ),
      //               TextFormField(
      //                 maxLength: 1,
      //                 keyboardType: TextInputType.number,
      //                 autovalidateMode: AutovalidateMode.onUserInteraction,
      //                 validator: ValidateText.certificationCode,
      //                 decoration: const InputDecoration(filled: true),
      //                 onChanged: (text) {
      //                   setCertificationCode(int.parse(text));
      //                 },
      //               ),
      //               TextFormField(
      //                 maxLength: 1,
      //                 keyboardType: TextInputType.number,
      //                 autovalidateMode: AutovalidateMode.onUserInteraction,
      //                 validator: ValidateText.certificationCode,
      //                 decoration: const InputDecoration(filled: true),
      //                 onChanged: (text) {
      //                   setCertificationCode(int.parse(text));
      //                 },
      //               ),
      //               const SizedBox(
      //                 height: 16,
      //               ),
      //               const SizedBox(
      //                 height: 16,
      //               ),
      //               ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   elevation: 0,
      //                   backgroundColor: const Color(0xFF096F89),
      //                   fixedSize: const Size(300, 50),
      //                   foregroundColor: Colors.white,
      //                 ),
      //                 onPressed: () {
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(
      //                       builder: (context) => const Home(),
      //                     ),
      //                   );
      //                 },
      //                 child: const Text('電話番号を認証',
      //                     style: TextStyle(
      //                         fontSize: 16.0, fontWeight: FontWeight.w500)),
      //               ),
      //             ],
      //           )),
      //     ],
      //   ),
      // ),
    );
  }
}

class ValidateText {
  static String? certificationCode(String? value) {
    if (value != null) {
      String pattern = r'^[0-9]';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(value)) {
        return '数字のみを入力してください';
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
