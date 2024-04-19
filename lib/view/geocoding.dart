import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meemo/model/address.dart';
part 'geocoding.g.dart';

@riverpod
class GeocodingNotifire extends _$GeocodingNotifire {
  late bool isServiceEnabled;
  late LocationPermission permission;

  @override
  Future<void> build() async {
    //Geolocator利用確認
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    //位置情報許可確認
    permission = await Geolocator.checkPermission();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark> getPlacemarkFromPosition(
      {required double latitude, required double longitude}) async {
    final placeMarks = await GeocodingPlatform.instance!
        .placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks[0];
    return placeMark;
  }

  Future<Address> getCurrentAddress() async {
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
}
