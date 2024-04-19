// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:meemo/login.dart';
// import 'package:meemo/Account/create_account.dart';
// // import 'package:meemo/gen/assets.gen.dart';

// class StartScreen extends StatelessWidget {
//   const StartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //ローカライズクラスを取得
//     final l10n = L10n.of(context);
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: Text(l10n.startScreenTitle),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/logo.png'),
//             Container(
//               margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
//               child: Text(
//                 l10n.catchCopy,
//                 style: const TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF17AB8B),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 side: const BorderSide(
//                   color: Colors.black,
//                   width: 0.5,
//                 ),
//                 elevation: 0,
//                 backgroundColor: const Color.fromARGB(255, 246, 246, 246),
//                 fixedSize: const Size.fromWidth(300),
//               ),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const CreateAccount(),
//                   ),
//                 );
//               },
//               child: Text(l10n.newUser),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 side: const BorderSide(
//                   color: Colors.black,
//                   width: 0.5,
//                 ),
//                 elevation: 0,
//                 backgroundColor: const Color.fromARGB(255, 246, 246, 246),
//                 fixedSize: const Size.fromWidth(300),
//               ),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const Login(),
//                   ),
//                 );
//               },
//               child: Text(l10n.login),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meemo/login.dart';
import 'package:meemo/Account/create_account.dart';

// import 'package:meemo/gen/assets.gen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ローカライズクラスを取得
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(l10n.startScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            Container(
              margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
              child: Text(
                l10n.catchCopy,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF17AB8B),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                fixedSize: (const Size(280, 60)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateAccount(),
                  ),
                );
              },
              child: Text(l10n.newUser),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                fixedSize: (const Size(280, 60)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: Text(l10n.login),
            ),
          ],
        ),
      ),
    );
  }
}
