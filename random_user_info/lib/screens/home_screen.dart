import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{
  List<dynamic> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async{
    final res = await http.get(Uri.parse('https://randomuser.me/api/?results=20'));
    
    try{
      if(res.statusCode == 200){
        final data = json.decode(res.body);
        setState(() {
          users = data['results'];
          isLoading = false;
          errorMessage = null;
        });
      }else{
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load users: ${res.statusCode}';
        });
      }
    }catch(err){
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $err';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Users'),
      ),
      body: isLoading
            ? Center(child: CircularProgressIndicator(),)
            : errorMessage != null
              ? Center(child: Text(errorMessage!),)
              : GridView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index){
                    final user = users[index];
                    return Card(
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          Hero(
                            tag: user['login']['uuid'],
                            child: FadeInImage(
                              placeholder: AssetImage('assets/placeholder2.jpg'),
                              image: NetworkImage(user['picture']['large']),
                              fit: BoxFit.cover,
                              height: 400,
                              width: double.infinity,
                            ),
                          ),

                          Positioned.fill(
                            child: Image.network(user['picture']['large'], fit: BoxFit.cover,),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${user['name']['first']} ${user['dob']['age']}', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text('${user['location']['country']}', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),),
                                    ],
                                  ),

                                  Icon(Icons.favorite_border, color: Colors.white,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}