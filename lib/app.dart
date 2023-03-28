
import 'data/preference/local_preference.dart';

class App {
  UserLocalStorage get userLocalStorage => _userStorage;
  late UserLocalStorage _userStorage;

  Future<void> setup() async {
    _userStorage = UserLocalStorage();
    await _userStorage.load();
  }
}
