import 'package:tostign/interfaces/repository_interface.dart';
import 'package:tostign/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}
