import 'package:bloc/bloc.dart';
import 'package:fake_shop_app/data/models/category_model.dart';
import 'package:fake_shop_app/data/models/product_model.dart';
import 'package:fake_shop_app/data/repository/product_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsDataState> {
  ProductRepository repository;
  late List<ProductModel> products;
  late List<Category> categories;

  ProductsCubit(this.repository) : super(ProductsCubitInitial()) {
    getAllData();
  }

  Future<void> getAllData() async {
    emit(ProductsDataLoading());
    products = await getAllProducts();
    categories = await getAllCategories();
    emit(ProductsDataLoaded(products: products, categories: categories));
  }

  Future<List<ProductModel>> getAllProducts() async {
    return await repository.getAllProducts();
  }

  Future<List<Category>> getAllCategories() async {
    return await repository.getAllCategories();
  }

  List<String> get allCategoriesName {
    return List<String>.generate(
        categories.length, (index) => categories[index].name);
  }
}
