import 'package:yaho/models/contact_model.dart';

abstract class ContactState {
  const ContactState();
}

class ContactLoading extends ContactState {
  const ContactLoading();
}

class ContactLogged extends ContactState {
  final List<ContactModel> data;
  final bool? isFinish;

  const ContactLogged({required this.data, this.isFinish});
}

class ContactNoData extends ContactState {
  const ContactNoData();
}

class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);
}
