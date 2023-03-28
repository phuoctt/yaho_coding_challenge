import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaho/features/widgets/avatar.dart';
import 'package:yaho/models/contact_model.dart';

import '../../bloc/app/app_cubit.dart';

class ItemContactListView extends StatelessWidget {
  final ContactModel data;

  const ItemContactListView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode =
        BlocProvider.of<AppCubit>(context).state.theme ?? Brightness.light;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      decoration: BoxDecoration(
        color: themeMode == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          AvatarWidget(
            height: 80,
            width: 80,
            imageUrl: data.avatar??'',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.fullName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
                const SizedBox(height: 10),
                Text(data.email??'',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14.0)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
