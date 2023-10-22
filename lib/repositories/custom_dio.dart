import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lista_contatos/repositories/dio_interceptions.dart';

class CustonDio {
  final _dio = Dio();

  Dio get dio => _dio;

  CustonDio() {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
    _dio.interceptors.add(DioInterceptor());
  }
}