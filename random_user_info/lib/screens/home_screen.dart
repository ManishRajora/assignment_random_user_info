import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_user_info/screens/user_details_screen.dart';

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
  final Set<String> _favorites = {};

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

  void _toggleFavorite(String uuid){
    setState(() {
      if(_favorites.contains(uuid)){
        _favorites.remove(uuid);
      }else{
        _favorites.add(uuid);
      }
    });
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
                    final uuid = user['login']['uuid'];
                    final isFavorite = _favorites.contains(uuid);

                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: user, id: uuid,)));
                      },
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            Hero(
                              tag: uuid,
                              child: FadeInImage(
                                placeholder: AssetImage('assets/placeholder2.jpg'),
                                image: NetworkImage(user['picture']['large']),
                                fit: BoxFit.cover,
                                height: 400,
                                width: double.infinity,
                              ),
                            ),
                      
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                color: Colors.black38,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${user['name']['first']}, ${user['dob']['age']}', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        Text('${user['location']['country']}', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                        ),),
                                      ],
                                    ),
                      
                                    IconButton(
                                      onPressed: (){
                                        _toggleFavorite(uuid);
                                      },
                                      icon: isFavorite
                                            ? Icon(Icons.favorite, color: Colors.red,)
                                            : Icon(Icons.favorite_border, color: Colors.white,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}