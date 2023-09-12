import 'package:fake_shop_app/data/data_sources/api/products_api.dart';
import 'package:fake_shop_app/data/models/category_model.dart';
import 'package:fake_shop_app/data/models/product_model.dart';

class ProductRepository {
  ProductsDataApi apiServices;

  ProductRepository(this.apiServices);

  Future<List<ProductModel>> getAllProducts() async {
    final data = await apiServices.getAllProducts();
    List<ProductModel> products =
        data.map((product) => ProductModel.fromJson(product)).toList();
    return products;
  }

  Future<List<Category>> getAllCategories() async {
    final data = await apiServices.getAllCategories();
    List<Category> categories =
        data.map((category) => Category.fromJson(category)).toList();
    return categories;
  }
}
