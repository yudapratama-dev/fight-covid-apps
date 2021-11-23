import 'dart:convert';

import 'package:capstone_apps/common/exception.dart';
import 'package:capstone_apps/data/models/city_model.dart';
import 'package:capstone_apps/data/models/city_response.dart';
import 'package:capstone_apps/data/models/hospital_model.dart';
import 'package:capstone_apps/data/models/hospital_response.dart';
import 'package:capstone_apps/data/models/province_model.dart';
import 'package:capstone_apps/data/models/province_response.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

abstract class LocationRemoteDataSource {
  Future<List<ProvinceModel>> getDataProvince();
  Future<List<CityModel>> getDataCity(String provinceId);
  Future<List<HospitalModel>> getDataHospital(String provinceId, String cityId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  static const BASE_URL = "https://rs-bed-covid-api.vercel.app/api";

  final http.Client client;

  LocationRemoteDataSourceImpl({required this.client});

  Logger _logger = Logger();

  @override
  Future<List<ProvinceModel>> getDataProvince() async {
    final response = await client.get(Uri.parse("$BASE_URL/get-provinces"));

    _logger.d(response.body);

    if (response.statusCode == 200) {
      return ProvinceResponse.fromJson(json.decode(response.body)).provinces;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CityModel>> getDataCity(String provinceId) async {
    final response = await client
        .get(Uri.parse("$BASE_URL/get-cities?provinceid=$provinceId"));

    _logger.d(response.body);

    if (response.statusCode == 200) {
      return CityResponse.fromJson(json.decode(response.body)).cities;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<HospitalModel>> getDataHospital(
    String provinceId,
    String cityId,
  ) async {
    final response = await client.get(
      Uri.parse(
          "$BASE_URL//get-hospitals?provinceid=$provinceId&cityid=$cityId&type=1"),
    );

    _logger.d(response.body);

    if (response.statusCode == 200) {
      return HospitalResponse.fromJson(json.decode(response.body)).hospitals;
    } else {
      throw ServerException();
    }
  }
}
