import 'dart:ffi' as prefix;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meemo/view/geocoding.dart';
import 'package:meemo/model/address.dart';
import 'package:geocoding/geocoding.dart';

class Home extends ConsumerWidget {
  final Key? key;
  Home({this.key}) : super(key: key);

  //遅延初期化
  late GoogleMapController mapController;
  //位置変数
  LatLng? _initialPosition;

  late TextEditingController _boardingPlaceController;
  late TextEditingController _Destination;

  // Future<void> _loadInitialPosition() async {
  //   final currentPosition = await Geolocator.getCurrentPosition();
  //   _initialPosition =
  //       LatLng(currentPosition.latitude, currentPosition.longitude);
  // }

  // Future<void> _loadInitialPosition(WidgetRef ref) async {
  //   final currentPosition =
  //       await ref.read(geocodingNotifireProvider.notifier).getInitialPosition();
  //   _initialPosition = currentPosition;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 初期化ロジックをここに移動する
    // _loadInitialPosition(ref);
    _boardingPlaceController = TextEditingController();
    _Destination = TextEditingController();

    // デバイスの高さを取得する
    double screenHeight = MediaQuery.of(context).size.height;
    // デバイスの横幅を取得する
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('meemo'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          ref
              .read(geocodingNotifireProvider.notifier)
              .getCurrentAddress(), //アドレス取得
          // ref
          //     .read(geocodingNotifireProvider.notifier)
          //     .getInitialPosition(), //経度緯度取得
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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

          List<dynamic> results = snapshot.data ?? [];
          Address address = results[0] as Address; //アドレス
          // _initialPosition = const LatLng(35.944571, 136.186228); //緯度経度
          if (snapshot.hasData) {
            _boardingPlaceController = TextEditingController(
                text: address.prefecture + address.city + address.street);
            _Destination = TextEditingController();

            return Stack(
              children: [
                // マップを上部に表示
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // bottom: screenHeight * 0.28, // フォームの高さを指定
                  child: _googleMap(ref, screenHeight),
                ),
                // 送迎依頼フォームを下部に表示
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.33,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(60)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                    context, screenHeight, screenWidth);
                              },
                              child: const Text(
                                '送迎を依頼する',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          '乗車地',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextField(
                          controller: _boardingPlaceController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // const Text(
                        //   '目的地',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //   ),
                        // ),
                        // TextField(
                        //   controller: _Destination,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // TextFieldがタップされたときにBottomSheetを表示する
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 500, // BottomSheetの高さを設定
                                  color: Colors.white,
                                  child: const Center(
                                    child: Text('BottomSheet'),
                                  ),
                                );
                              },
                            );
                          },
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'タップしたらモーダル表示させたい...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
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

  //Map表示
  Widget _googleMap(WidgetRef ref, double screenHeight) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            //初期化
            mapController = controller;
          },
          initialCameraPosition: _initialPosition != null
              ? CameraPosition(
                  target: _initialPosition!,
                  zoom: 14.0,
                )
              : const CameraPosition(
                  target: LatLng(0, 0), // デフォルトの緯度経度、例えば原点を設定
                  zoom: 14.0,
                ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.35),
          markers: _createMarker(),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onCameraMove: (CameraPosition newPosition) async {
            //地図が移動したときの処理
            Placemark placemark = await ref
                .read(geocodingNotifireProvider.notifier)
                .getPlacemarkFromPosition(
                    latitude: newPosition.target.latitude,
                    longitude: newPosition.target.longitude);

            //取得した住所を乗車地のTextFieldに表示する
            Address address = Address(
              prefecture: placemark.administrativeArea ?? '',
              city: placemark.locality ?? '',
              street: placemark.street ?? '',
            );

            _boardingPlaceController = TextEditingController(
                text: address.prefecture + address.city + address.street);

            // ref
            //     .read(geocodingNotifireProvider.notifier)
            //     .setBoardingPlaceAddress(address);

            // これにより、getPlacemarkFromPositionの呼び出しと、
            // setBoardingPlaceAddressでTextFieldに住所が表示される

            Marker(
              markerId: const MarkerId("marker_1"),
              position: LatLng(
                  newPosition.target.latitude, newPosition.target.longitude),
            );
          },
        ),
        Positioned(
          right: 10,
          bottom: screenHeight * 0.35,
          child: _goToCurrentPositionButon(),
        ),
      ],
    );
  }

  //現在地ボタン押下
  Widget _goToCurrentPositionButon() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(55, 55),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        //現在地を取得してmap移動
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
              zoom: 14,
            ),
          ),
        );
      },
      child: const Icon(Icons.near_me_outlined),
    );
  }
}

//マーカーを刺す
Set<Marker> _createMarker() {
  return {
    const Marker(
      markerId: MarkerId("marker_1"),
      position: LatLng(35.944571, 136.186228),
    ),
  };
}

class ButtonColorNotifier extends ChangeNotifier {
  Color _buttonColor = const Color.fromARGB(255, 246, 246, 246);

  Color get buttonColor => _buttonColor;

  void changeColor(Color newColor) {
    _buttonColor = newColor;
    notifyListeners(); // 状態の変更をリスナーに通知します
  }
}

void _showBottomSheet(
    BuildContext context, double screenHeight, double screenWidth) {
  Color _buttonColor = const Color.fromARGB(255, 246, 246, 246);
  final addressList = [
    '自宅\n京都府舞鶴市引土258−2',
    '舞鶴駅\n京都府舞鶴市引土258−2',
    '舞鶴赤十字病院\n都府舞鶴市引土258−2',
  ];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: screenHeight * 0.95,
        width: screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 60.0, right: 60.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "乗車地を選択"),
              ),
            ),
            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 60.0, right: 60.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "目的地を選択"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  '詳細設定',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: _buttonColor,
                      fixedSize: (const Size(130, 18)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                    },
                    child: const Text(
                      '履歴',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: _buttonColor,
                      fixedSize: (const Size(130, 18)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                    },
                    child: const Text(
                      'お気に入り',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: _buttonColor,
                      fixedSize: (const Size(130, 18)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                    },
                    child: const Text(
                      'Map',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ここにListViewを追加します
            Expanded(
              child: ListView.builder(
                itemCount: addressList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addressList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class TextFieldWithBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TextFieldがタップされたときにBottomSheetを表示する
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200, // BottomSheetの高さを設定
              color: Colors.white,
              child: const Center(
                child: Text('BottomSheet'),
              ),
            );
          },
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tap here to show BottomSheet',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
