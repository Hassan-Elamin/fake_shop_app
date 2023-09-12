import 'package:dio/dio.dart';
import 'package:fake_shop_app/constants/strings.dart';

class ProductsDataApi {
  late Dio _dio;

  ProductsDataApi() {
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );
    _dio = Dio(options);
  }

  Future<List<dynamic>> getAllProducts() async {
    try {
      Response response = await _dio.get(PRODUCTS_END_POINT);
      return response.data['data'];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getAllCategories() async {
    try {
      Response response = await _dio.get(CATEGORIES_END_POINT);
      return response.data['data'];
    } catch (e) {
      return [];
    }
  }
}
