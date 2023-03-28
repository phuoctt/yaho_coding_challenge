import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app/app_cubit.dart';

enum ListModeType { grid_view, list_view }

class IconTransferList extends StatefulWidget {
  final ListModeType mode;
  final Function? onPressed;

  const IconTransferList({Key? key, required this.mode, this.onPressed})
      : super(key: key);

  @override
  _IconTransferListState createState() => _IconTransferListState();
}

class _IconTransferListState extends State<IconTransferList> {
  @override
  Widget build(BuildContext context) {
    final themeMode =
        BlocProvider.of<AppCubit>(context).state.theme ?? Brightness.light;
    return IconButton(
      icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
          child: widget.mode == ListModeType.list_view
              ? Image.asset(
                  'assets/images/icon_file_manager_gridview.png',
                  height: 24,
                  key: const ValueKey('icon1'),
                  color: themeMode == Brightness.light
                      ? Colors.black
                      : Colors.white,
                )
              : Image.asset(
                  'assets/images/icon_file_manager_listview.png',
                  height: 24,
                  key: const ValueKey('icon2'),
                  color: themeMode == Brightness.light
                      ? Colors.black
                      : Colors.white,
                )),
      onPressed: () => widget.onPressed?.call(),
    );
  }
}
