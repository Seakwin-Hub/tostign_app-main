import 'package:tostign/features/brands/domain/models/brands_model.dart';
import 'package:tostign/features/item/domain/models/item_model.dart';

abstract class BrandsServiceInterface {
  Future<List<BrandModel>?> getBrandList();
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset});
}
