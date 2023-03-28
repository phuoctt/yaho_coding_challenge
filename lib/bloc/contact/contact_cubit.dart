import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../data/preference/local_preference.dart';
import '../../models/contact_model.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final UserLocalStorage storage;

  ContactCubit(this.storage) : super(const ContactLoading());

  Future<void> onLoadContacts(
      {int? page = 1, List<ContactModel>? dataOld}) async {
    try {
      emit(const ContactLoading());
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

      final result = ContactResponse.fromJson(json.decode(response.body));
      final data = List<ContactModel>.from(dataOld ?? [])..addAll(result.data ?? []);
      if (data.isEmpty) {
        emit(const ContactNoData());
      } else {
        emit(ContactLogged(
            data: data,
            isFinish: _isFinish(
                total: result.total,
                perPage: result.perPage,
                pageNumber: page)));
      }
    } catch (err) {
      emit(const ContactError('Has an error, please try again'));
    }
  }

  bool _isFinish(
      {required int? total, required int? perPage, required int? pageNumber}) {
    if (total == null || perPage == null || pageNumber == null) return false;
    return total <= perPage * pageNumber;
  }
}
