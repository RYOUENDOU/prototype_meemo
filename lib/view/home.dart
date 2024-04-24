import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // デバイスの高さを取得する
    double screenHeight = MediaQuery.of(context).size.height;
    // デバイスの横幅を取得する
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('現在位置'),
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
          // _initialPosition = results[1] as LatLng; //緯度経度
          if (snapshot.hasData) {
            final boardingPlaceTextController = TextEditingController(
                text: address.prefecture + address.city + address.street);

            return Stack(
              children: [
                // マップを上部に表示
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: screenHeight * 0.28, // フォームの高さを指定
                  child: _googleMap(ref),
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
                          controller: boardingPlaceTextController,
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
                          controller: boardingPlaceTextController,
                          decoration: const InputDecoration(
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

  //Map表示
  Widget _googleMap(WidgetRef ref) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            //初期化
            mapController = controller;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(35.944571, 136.186228),
            zoom: 14.0,
          ),
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

            ref
                .read(geocodingNotifireProvider.notifier)
                .setBoardingPlaceAddress(address);

            //これにより、getPlacemarkFromPositionの呼び出しと、
            //setBoardingPlaceAddressでTextFieldに住所が表示される
          },
        ),
        Positioned(
          right: 10,
          bottom: 50,
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
