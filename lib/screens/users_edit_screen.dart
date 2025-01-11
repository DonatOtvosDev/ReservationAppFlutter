import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/providers/users.dart';

import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';

import 'package:reservation_app/widgets/users_screen/filter_selector.dart';
import 'package:reservation_app/widgets/users_screen/user_item.dart';

import 'package:reservation_app/modells/user_info_modell.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  static const routeName = "/users";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _didRun = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String filter = "";
  Map keys = {};

  void bannUser(userId) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UsersProvider>(context, listen: false)
        .bannUser(userId, keys[filter])
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void allowUser(userId) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<UsersProvider>(context, listen: false)
        .allowUser(userId, keys[filter])
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void changeFilter(key) {
    setState(() {
      filter = key;
      _isLoading = true;
    });
    Provider.of<UsersProvider>(context, listen: false)
        .fetchAndSetUsers(filter: keys[key])
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      AppLocalizations appLocalizations = AppLocalizations.of(context)!;

      setState(() {
        _isLoading = true;
        filter = appLocalizations.alluser;

        keys = {
          appLocalizations.alluser: null,
          appLocalizations.users: "user",
          appLocalizations.bannedusers: "banneduser",
          appLocalizations.admins: "admin"
        };
      });
      Provider.of<UsersProvider>(context, listen: false)
          .fetchAndSetUsers()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _didRun = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    List<UserData> items = Provider.of<UsersProvider>(context).items;
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(appLocalizations.editusers),
        requiredLogin: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserFilterSelector(filter, changeFilter, [
                        appLocalizations.alluser,
                        appLocalizations.users,
                        appLocalizations.bannedusers,
                        appLocalizations.admins
                      ]),
                      if (items.isEmpty)
                        Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(appLocalizations.nouseravailable)),
                      if (items.isNotEmpty)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (ctx, i) =>
                                UserItem(items[i], allowUser, bannUser)),
                      if (items.isNotEmpty && items.length % 10 == 0)
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: _isLoadingMore
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLoadingMore = true;
                                    });
                                    Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .loadMoreUsers(filter: keys[filter])
                                        .then((_) {
                                      setState(() {
                                        _isLoadingMore = false;
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_circle_down,
                                    size: 35,
                                    color: Theme.of(context).primaryColor,
                                  )),
                        )
                    ]),
              ),
            ),
      drawer: const AppDrawer(),
    );
  }
}
