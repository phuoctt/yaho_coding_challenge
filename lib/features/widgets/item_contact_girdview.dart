import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaho/features/widgets/avatar.dart';

import '../../bloc/app/app_cubit.dart';
import '../../models/contact_model.dart';

class ItemContactGirdView extends StatelessWidget {
  final ContactModel data;

  const ItemContactGirdView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode =
        BlocProvider.of<AppCubit>(context).state.theme ?? Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      child: Column(
        children: [
          AvatarWidget(
            height: 80,
            width: 80,
            imageUrl: data.avatar ?? '',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Text(
                  data.fullName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16.0),
                ),
                const SizedBox(height: 6),
                Text(
                  data.email ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 12.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
