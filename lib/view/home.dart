import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meemo/view/geocoding.dart';
import 'package:meemo/model/address.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  // //遅延初期化
  // late GoogleMapController mapController;
  // //位置変数
  // LatLng? _initialPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('現在'),
      ),
      body: FutureBuilder(
        future:
            ref.read(geocodingNotifireProvider.notifier).getCurrentAddress(),
        builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            final boardingPlaceTextController = TextEditingController(
                text: snapshot.data!.prefecture +
                    snapshot.data!.city +
                    snapshot.data!.street);

            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300.0,
                width: MediaQuery.of(context).size.width, // 画面の幅いっぱいに広げる
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('乗車地'),
                    TextField(
                      controller: boardingPlaceTextController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    const Text('目的地'),
                    TextField(
                      controller: boardingPlaceTextController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Column(
              children: [
                Center(
                  child: Text('データが存在しません'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  //   //Map表示
  // Widget _googleMap() {
  //   return Stack(
  //     children: [
  //       GoogleMap(
  //         onMapCreated: (controller) {
  //           //初期化
  //           mapController = controller;
  //         },
  //         initialCameraPosition: CameraPosition(
  //           target: _initialPosition!,
  //           zoom: 14.0,
  //         ),
  //         myLocationEnabled: true,
  //         myLocationButtonEnabled: false,
  //       ),
  //       Positioned(
  //         right: 10,
  //         bottom: 50,
  //         child: _goToCurrentPositionButon(),
  //       ),
  //     ],
  //   );
  // }

  // //現在地ボタン押下
  // Widget _goToCurrentPositionButon() {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       minimumSize: const Size(55, 55),
  //       backgroundColor: Colors.white,
  //       foregroundColor: Colors.black,
  //       shape: const CircleBorder(),
  //     ),
  //     onPressed: () async {
  //       //現在地を取得してmap移動
  //       Position currentPosition = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target:
  //                 LatLng(currentPosition.latitude, currentPosition.longitude),
  //             zoom: 14,
  //           ),
  //         ),
  //       );
  //     },
  //     child: const Icon(Icons.near_me_outlined),
  //   );
  // }
}

// class Home extends StatefulWidget {
//   const Home({super.key});
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   //遅延初期化
//   late GoogleMapController mapController;
//   //位置変数
//   LatLng? _initialPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   //位置情報の許可確認
//   void _getUserLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // ユーザーが位置情報へのアクセスを拒否した場合の処理
//         return;
//       }
//     }

//     //ユーザーの現在地取得
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _initialPosition = LatLng(position.latitude, position.longitude);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // デバイスの高さを取得する
//     double screenHeight = MediaQuery.of(context).size.height;
//     // デバイスの高さを取得する
//     // double screenWidth = MediaQuery.of(context).size.width;

//     //ローカライズクラスを取得
//     // final l10n = L10n.of(context);
//     return Scaffold(
//       body: _initialPosition == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       child: _googleMap(),
//                       height: screenHeight * 0.7,
//                       width: double.infinity,
//                     ),
//                     Transform.translate(
//                       // e.g: vertical negative margin
//                       offset: const Offset(0, -10), //仮
//                       child: Container(
//                         height: screenHeight * 0.3,
//                         width: double.infinity,
//                         child: _card(),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//     );
//   }

//   //Map表示
//   Widget _googleMap() {
//     return Stack(
//       children: [
//         GoogleMap(
//           onMapCreated: (controller) {
//             //初期化
//             mapController = controller;
//           },
//           initialCameraPosition: CameraPosition(
//             target: _initialPosition!,
//             zoom: 14.0,
//           ),
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//         ),
//         Positioned(
//           right: 10,
//           bottom: 50,
//           child: _goToCurrentPositionButon(),
//         ),
//       ],
//     );
//   }

//   //現在地ボタン押下
//   Widget _goToCurrentPositionButon() {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(55, 55),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         shape: const CircleBorder(),
//       ),
//       onPressed: () async {
//         //現在地を取得してmap移動
//         Position currentPosition = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);
//         mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target:
//                   LatLng(currentPosition.latitude, currentPosition.longitude),
//               zoom: 14,
//             ),
//           ),
//         );
//       },
//       child: const Icon(Icons.near_me_outlined),
//     );
//   }
// }

// //カード表示
// Widget _card() {
//   return const Card(
//     child: Column(
//       children: [
//         Padding(padding: EdgeInsets.all(10)),
//         Text(
//           '送迎依頼',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Form(
//           child: Column(
//             children: [
//               Text('乗車時', textAlign: TextAlign.left),
//               SizedBox(
//                 width: 300, //仮
//                 child: TextField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5)),
//                       filled: true,
//                       hintText: '乗車地を設定'),
//                 ),
//               ),
//               Text('目的地'),
//               SizedBox(
//                 // height: 20.0,
//                 width: 300,
//                 child: TextField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.black, width: 0.5)),
//                       filled: true,
//                       hintText: '目的地を設定'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//     // color: Color(0xFFFFFFFF),
//   );
// }
