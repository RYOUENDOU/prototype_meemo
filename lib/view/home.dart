import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meemo/model/geocoding.dart';
import 'package:meemo/model/address.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class Home extends ConsumerWidget {
  final Key? key;
  Home({this.key}) : super(key: key);

  //遅延初期化
  late GoogleMapController mapController;

  late TextEditingController _boardingPlaceController;
  // late TextEditingController _Destination;

  //GooglePlace
  // late GooglePlace googlePlace;

  //textFieldのタップを感知
  final FocusNode focusNode = FocusNode();
  //モーダルが表示されたかどうかを示すフラグ
  bool bottomSheetShown = false;
  //デフォ現在地
  late String defaultPlace;

//モーダルは１回のみの表示に制御する
  void showBottomSheetOnce(BuildContext context, double screenHeight,
      double screenWidth, WidgetRef ref) {
    // モーダルがまだ表示されていない場合のみ表示する
    if (!bottomSheetShown) {
      _showModal(context, screenHeight, screenWidth, ref, defaultPlace);
      bottomSheetShown = true; // フラグを更新して、次回以降の呼び出しを防ぐ
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _boardingPlaceController = TextEditingController();
    // _Destination = TextEditingController();

    // デバイスの高さを取得する
    double screenHeight = MediaQuery.of(context).size.height;
    // デバイスの横幅を取得する
    double screenWidth = MediaQuery.of(context).size.width;

    //textFieldがタップされたらモーダルを表示する
    focusNode.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
      if (focusNode.hasFocus) {
        showBottomSheetOnce(context, screenHeight, screenWidth, ref);
      }
    });

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('meemo'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // scaffoldKey.currentState?.openDrawer();
            Navigator.of(context).pop();
          },
        ),
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // const DrawerHeader(
            //   child: Text('Drawer Header'),
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            // ),
            ListTile(
              title: const Text('お知らせ'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('お気に入りスポット'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('支払い方法'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('よくある質問'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('問い合わせ'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              // isThreeLine: true,
              title: const Text('・meemoについて'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('・meemoについて'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
            ListTile(
              title: const Text('ドライバーモード'),
              onTap: () {
                // メニューアイテムがタップされたときの処理
              },
            ),
          ],
        ),
      ),
      // 他のプロパティ
      body: FutureBuilder(
        future: Future.wait(
            [ref.read(geocodingNotifireProvider.notifier).getCurrentAddress()]),
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
          bottomSheetShown = false;

          if (snapshot.hasData) {
            _boardingPlaceController = TextEditingController(
                text: address.prefecture + address.city + address.street);
            //モーダルに渡す用の現在地
            defaultPlace = address.prefecture + address.city + address.street;
            // _Destination = TextEditingController();

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
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: Text(
                              '送迎を依頼する',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
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
                          focusNode: focusNode,
                          controller: _boardingPlaceController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '目的地',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextField(
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: '目的地',
                            border: OutlineInputBorder(),
                          ),
                        ),
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

  // Map表示
  Widget _googleMap(WidgetRef ref, double screenHeight) {
    return FutureBuilder<LatLng>(
      future: getPosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // データがまだ取得されていない場合はローディングインジケーターを表示する
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // エラーが発生した場合はエラーメッセージを表示する
          return Center(
            child: Text('エラーが発生しました: ${snapshot.error}'),
          );
        } else {
          // データが正常に取得された場合はGoogleMapウィジェットを表示する
          LatLng currentPosition = snapshot.data!;
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 18,
                ),
                padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.35),
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
                    position: LatLng(newPosition.target.latitude,
                        newPosition.target.longitude),
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
      },
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
        LatLng currentPosition = await getPosition();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
              zoom: 18,
            ),
          ),
        );
      },
      child: const Icon(Icons.near_me_outlined),
    );
  }
}

//現在地を取得する関数
Future<LatLng> getPosition() async {
  Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(currentPosition.latitude, currentPosition.longitude); // 緯度経度
}

// //マーカーを刺す
// Set<Marker> _createMarker() {
//   return {
//     const Marker(
//       markerId: MarkerId("marker_1"),
//       position: LatLng(35.944571, 136.186228),
//     ),
//   };
// }

//モーダル表示関数
void _showModal(BuildContext context, double screenHeight, double screenWidth,
    WidgetRef ref, String defaultPlace) {
  // コントローラーを初期化
  late TextEditingController boardingPlaceController;
  late TextEditingController destinationController;

  var selectedIndex = -1;
  //乗車地又は目的地の変更
  bool placeFlag = true;
  const addressList = [
    {
      'name': '自宅',
      'address1': '京都府',
      'address2': '舞鶴市',
      'address3': '引土258−2',
      'latitude': 1000,
      'longitude': 1000,
    },
    {
      'name': '舞鶴駅',
      'address1': '京都府',
      'address2': '舞鶴市',
      'address3': '引土258−2',
      'latitude': 1000,
      'longitude': 1000,
    },
    {
      'name': '舞鶴赤十字病院',
      'address1': '京都府',
      'address2': '舞鶴市',
      'address3': '引土258−2',
      'latitude': 1000,
      'longitude': 1000,
    },
  ];

  // コントローラーを変数の値で初期化
  boardingPlaceController = TextEditingController(text: defaultPlace);
  destinationController = TextEditingController(text: "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      //textFieldのタップを感知
      final FocusNode focusNodeBoardingPlace = FocusNode();
      final FocusNode focusNodeDestination = FocusNode();

      //乗車地のtextFieldがタップされたらplaceFlagをtureに
      focusNodeBoardingPlace.addListener(() {
        if (focusNodeBoardingPlace.hasFocus) {
          placeFlag = true;
        }
      });

      //目的地のtextFieldがタップされたらplaceFlagをfalseに
      focusNodeDestination.addListener(() {
        if (focusNodeDestination.hasFocus) {
          placeFlag = false;
        }
      });

      return Container(
        height: screenHeight * 0.95,
        width: screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 60.0, right: 60.0),
              child: TextField(
                focusNode: focusNodeBoardingPlace,
                onChanged: (value) {
                  print(value);
                },
                controller: boardingPlaceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "乗車地を選択"),
                //                   onEditingComplete: () {
                //   // Doneボタンが押されたときに値を保存する
                //   _saveTextValue();
                // },
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 60.0, right: 60.0),
              child: TextField(
                focusNode: focusNodeDestination,
                onChanged: (value) {
                  print(value);
                },
                controller: destinationController,
                decoration: const InputDecoration(
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
                      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
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
                      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
                      fixedSize: (const Size(130, 18)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                      // _list("お気に入り");
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
                      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
                      fixedSize: (const Size(130, 18)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'MAP',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ここにListViewを追加
            Expanded(
              child: ListView.builder(
                itemCount: addressList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected: selectedIndex == index ? true : false,
                    selectedTileColor: const Color.fromRGBO(145, 50, 50, 1),
                    onTap: () {
                      // テキストフィールドの値を更新する
                      placeFlag
                          ? boardingPlaceController.text =
                              addressList[index]['name'].toString()
                          : destinationController.text =
                              addressList[index]['name'].toString();
                    },
                    title: Text(
                        '${addressList[index]['name']}\n${addressList[index]['address1']}${addressList[index]['address2']}${addressList[index]['address3']}'),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    backgroundColor: const Color.fromRGBO(0, 36, 195, 1),
                    foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    fixedSize: (const Size(400, 50)),
                  ),
                  onPressed: () {
                    // ボタンが押されたときの処理
                    // _list("お気に入り");
                  },
                  child: const Text(
                    '依頼する',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0, bottom: 30),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(),
                      ),
                      elevation: 0,
                      foregroundColor: const Color.fromRGBO(0, 36, 195, 1),
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                      fixedSize: (const Size(400, 50)),
                    ),
                    onPressed: () {
                      // ボタンが押されたときの処理
                      // _list("お気に入り");
                    },
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      );
    },
  );
}
