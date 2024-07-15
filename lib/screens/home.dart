import 'package:bionic_interface/general_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bionic_interface/firebase_handler.dart';
import 'package:go_router/go_router.dart';
//TODO: change this to a different screen
// it should allow you to select and connect to a nearby hand and prompt you where to go?
// maybe have ble connection be a thing that happens before, also need something to log in

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  /*
  elements on this page:
    - show ble connection status (possibly in a corner?)
    - put up a pop up to connect to the correct device
    - navigate to other sections (only sections visible according to access)
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rebel Bionics"),
        actions: [
          const SizedBox.shrink(),
          Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bleStatusButtonCard(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: (){
                    //Todo this should only be available when connected + permissions are right
                    //Navigator.popAndPushNamed(context, "/grip");
                    context.go("/grip");
                  },
                  child: const Text("To Settings"),
              ),
              ElevatedButton(
                onPressed: (){
                  //Todo this should only be available when connected + permissions are right
                  //Navigator.popAndPushNamed(context, "/plot");
                  context.go("/plot");
                },
                child: const Text("To Plot"),
              ),
            ],
          ),
          newUserButtonCard(context),
          ElevatedButton(
              onPressed: (){ context.go("/selectGrip");},
              child: const Text("Grip Selection Overview")
          ),

          ElevatedButton(onPressed: (){ context.go("/test");}, child: const Text("Test page")),
        ],
      ),

    );
  }

  Widget bleStatusButtonCard(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.bluetooth, color: Colors.white,),
          title: const Text("Hand Status", style: TextStyle(color: Colors.white),),
          splashColor: Theme.of(context).colorScheme.secondary,
          tileColor: Theme.of(context).colorScheme.primary,
          onTap: (){
            //Navigator.popAndPushNamed(context, "/ble");
            context.push("/ble");
          },
        ),
      ),
    );
  }

  Widget toSettingsButtonCard(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.front_hand, color: Colors.white,),
          title: const Text("Hand Settings", style: TextStyle(color: Colors.white),),
          splashColor: Theme.of(context).colorScheme.secondary,
          tileColor: Theme.of(context).colorScheme.primary,
          onTap: (){
            //Navigator.popAndPushNamed(context, "/grip");
            context.push("/grip");
          },
        ),
      ),
    );
  }

  Widget newUserButtonCard(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: const Icon(Icons.login, color: Colors.white,),
          title:  Provider.of<FirebaseHandler>(context, listen: true).loggedIn?
            const Text("View Profile", style: TextStyle(color: Colors.white))
                : const Text("Login", style: TextStyle(color: Colors.white),),
          splashColor: Theme.of(context).colorScheme.secondary,
          tileColor: Theme.of(context).colorScheme.primary,
          onTap: (){
            //Navigator.popAndPushNamed(context, "/selectAccount");
            print(Provider.of<FirebaseHandler>(context, listen: false).loggedIn);
            Provider.of<FirebaseHandler>(context, listen: false).loggedIn?
              context.go("/profile") : context.go("/sign-in");
          },
        ),
      ),
    );
  }

}