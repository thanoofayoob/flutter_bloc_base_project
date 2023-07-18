// ignore_for_file: dead_code

import '../utils/app_configs.dart';

enum EndPoint { getCountryList, getCatergoryList, getCityList }

extension URLExtension on EndPoint {
  String get url {
    switch (this) {
      case EndPoint.getCountryList:
        return '${baseUrl}Applicationdata/get_country';
      case EndPoint.getCatergoryList:
        return '${baseUrl}Applicationdata/get_main_category';
      case EndPoint.getCityList:
        return '${baseUrl}Applicationdata/get_city';

      default:
        throw Exception(["Endpoint not defined"]);
    }
  }
}

extension RequestMode on EndPoint {
  RequestType get requestType {
    RequestType requestType = RequestType.get;

    switch (this) {
      case EndPoint.getCountryList:
      case EndPoint.getCityList:
      case EndPoint.getCatergoryList:
        requestType = RequestType.get;
        break;

        //GET API'S

        // case EndPoint.countryList:

        requestType = RequestType.get;
        break;

        //PUT API'S

        requestType = RequestType.put;
        break;

        break;

        // TODO: Handle this case.
        break;

        //delete api

        requestType = RequestType.delete;

        break;
    }
    return requestType;
  }
}

extension Token on EndPoint {
  bool get shouldAddToken {
    var shouldAdd = true;

    switch (this) {
      case EndPoint.getCountryList:
      case EndPoint.getCatergoryList:
      case EndPoint.getCityList:
        shouldAdd = false;
        break;

      default:
        break;
    }

    return shouldAdd;
  }
}
