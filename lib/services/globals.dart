import 'db.dart';
import 'models.dart';

class Global {

  static Category currentCategory;

  static void changeCategory(Category newCategory) {
    currentCategory = newCategory;
  }

  static final Map models = {
    Category: (data) => Category.fromFirestore(data),
    User: (data) => User.fromFirestore(data),
  };

  static final UserCollection<Category> categoryCollection = UserCollection<Category>(path: 'categories');
  static final UserDocument<User> userDocument = UserDocument<User>();

}