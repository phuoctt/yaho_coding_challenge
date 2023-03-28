import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app/app_cubit.dart';
import '../../bloc/contact/contact_cubit.dart';
import '../../bloc/contact/contact_state.dart';
import '../../models/contact_model.dart';
import '../widgets/icon_change_list.dart';
import '../widgets/item_contact_girdview.dart';
import '../widgets/item_contact_listview.dart';
import '../widgets/load_more.dart';

class ContactScreen extends StatefulWidget {
  final Brightness themeMode;

  const ContactScreen({Key? key, required this.themeMode}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  AppCubit get appCubit => BlocProvider.of<AppCubit>(context);

  ContactCubit get contactCubit => BlocProvider.of<ContactCubit>(context);

  late Brightness themeMode;
  ListModeType fileMode = ListModeType.list_view;
  int pageNumber = 1;

  @override
  void initState() {
    themeMode = widget.themeMode;
    contactCubit.onLoadContacts();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ContactScreen oldWidget) {
    themeMode = widget.themeMode;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconTransferList(
            mode: fileMode,
            onPressed: _updateListMode,
          ),
          IconButton(
              onPressed: _updateTheme,
              icon: Icon(widget.themeMode == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode))
        ],
      ),
      body: BlocBuilder<ContactCubit, ContactState>(
        buildWhen: (p, c) => c is ContactLogged || c is ContactNoData,
        builder: (context, state) {
          if (state is ContactLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ContactLogged) {
            final data = state.data;
            final isFinish = state.isFinish ?? false;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                      position: animation.drive(Tween(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0))),
                      child: child);
                },
                child: LoadMore(
                  key: Key(fileMode.toString()),
                  onLoadMore: () async => _loadMore(dataOld: data),
                  isFinish: isFinish,
                  child: fileMode == ListModeType.grid_view
                      ? _buildContactGirdView(data)
                      : _buildContactListView(data),
                ),
              ),
            );
          }
          if (state is ContactNoData) {
            return const Center(child: Text('No Data'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView _buildContactListView(List<ContactModel> data) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final item = data[index];
          return ItemContactListView(data: item);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        padding: const EdgeInsets.symmetric(vertical: 26),
        itemCount: data.length);
  }

  GridView _buildContactGirdView(List<ContactModel> data) {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 26,
          mainAxisSpacing: 26,
          mainAxisExtent: 180,
        ),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return ItemContactGirdView(data: item);
        });
  }

  void _updateTheme() {
    appCubit.onUpdateTheme(
        themeMode == Brightness.light ? Brightness.dark : Brightness.light);
  }

  void _updateListMode() {
    setState(() {
      fileMode = fileMode == ListModeType.grid_view
          ? ListModeType.list_view
          : ListModeType.grid_view;
    });
  }

  Future<bool> _loadMore({List<ContactModel>? dataOld}) async {
    pageNumber++;
    await contactCubit.onLoadContacts(
      dataOld: dataOld,
      page: pageNumber,
    );
    return true;
  }

  Future<void> _onRefresh() async {
    pageNumber = 1;
    await contactCubit.onLoadContacts();
  }
}
