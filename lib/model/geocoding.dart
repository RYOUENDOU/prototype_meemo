import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meemo/model/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'geocoding.g.dart';

@riverpod
class GeocodingNotifire extends _$GeocodingNotifire {
  late bool isServiceEnabled;
  late LocationPermission permission;
  Address? _boardingPlaceAddress;

  @override
  Future<void> build() async {
    //Geolocator利用確認
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    //Geolocator利用確認できない場合
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    //位置情報許可確認
    permission = await Geolocator.checkPermission();

    //位置情報許可が取れていたら
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    //位置情報許可が取れていない場合
    if (permission == LocationPermission.deniedForever) {
      return Future.error('位置情報許可なし');
    }
  }

  //現在地取得
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  //指定された緯度と経度から [Placemark] を取得する非同期関数
  Future<Placemark> getPlacemarkFromPosition({
    required double latitude, // 緯度
    required double longitude, // 経度
  }) async {
    //GeocodingPlatformを使用して座標からPlacemarkを取得
    final placeMarks =
        await GeocodingPlatform.instance!.placemarkFromCoordinates(
      latitude,
      longitude,
    );
    //取得したPlacemarkリストから最初の要素を返す
    final placeMark = placeMarks[0];
    return placeMark;
  }

  //住所情報取得
  Future<Address> getCurrentAddress() async {
    //緯度経度取得
    final currentPosition = await getCurrentPosition();
    //緯度経度の座標からPlacemarkを取得する関数
    final placeMark = await getPlacemarkFromPosition(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );
    //placeMarkの各プロパティをAddressに入れる
    final address = Address(
      prefecture: placeMark.administrativeArea ?? '',
      city: placeMark.locality ?? '',
      street: placeMark.street ?? '',
    );
    return address;
  }

  // 緯度経度のみ取得するメソッド
  Future<LatLng> getInitialPosition() async {
    //緯度経度取得
    final currentPosition = await getCurrentPosition();
    // 緯度と経度からLatLngオブジェクトを作成して返す
    LatLng initialPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    return initialPosition;
  }

  //マップが移動された時に住所を取得するメソッド
  Future<Address> getAddressInfoFromPosition(
      {required double latitude, required double longitude}) async {
    final placeMark = await getPlacemarkFromPosition(
        latitude: latitude, longitude: longitude);
    final address = Address(
      prefecture: placeMark.administrativeArea ?? '',
      city: placeMark.locality ?? '',
      street: placeMark.street ?? '',
    );
    return address;
  }

  //マップが移動された時に住所をセットするメソッド
  void setBoardingPlaceAddress(Address address) {
    _boardingPlaceAddress = address;
  }

  //乗車地の住所を取得するメソッド
  Address? get boardingPlaceAddress => _boardingPlaceAddress;
}
