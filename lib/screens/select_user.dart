import 'package:provider/provider.dart';
import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:bionic_interface/firebase_handler.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});


  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser>{

  @override
  void initState() {
    super.initState();
    print(Provider.of<FirebaseHandler>(context, listen: false).loggedIn);
    print(Provider.of<FirebaseHandler>(context, listen: false).currentUser);
  }

  @override
  Widget build(BuildContext context) {
    //update accounts
    Provider.of<GeneralHandler>(context).updateUserAccounts();
    final generalHandler = context.watch<GeneralHandler>();
    final users = generalHandler.userAccounts;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: (){
            Navigator.popAndPushNamed(context, "/home");
          },
        ),
        title: const Text("Select Account"),
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
            itemCount: users.length + 1,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              return index < users.length ? ListTile(
                title: Text(users[index]),
                selected: users[index] == generalHandler.currentUser.userName,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(users[index][0]),
                ),
              )
                  : ListTile(
                title: const Center(child: Icon(Icons.add)),
                onTap: (){Navigator.pushNamed(context, "/newUser");},
              );
            }
        ),
      ),
    );
  }

}