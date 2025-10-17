import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget{
  const UserDetailsScreen({super.key, required this.user, required this.id});

  final Map<String, dynamic> user;
  final String id;

  @override
  Widget build(BuildContext context) {
    final name = '${user['name']['first']} ${user['name']['last']}';
    final age = '${user['dob']['age']}';
    final city = '${user['location']['city']}';
    final country = '${user['location']['country']}';
    final image = user['picture']['large'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: id,
              child: FadeInImage(
                placeholder: AssetImage('assets/placeholder2.jpg'),
                image: NetworkImage(image),
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$name, $age', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),

                  SizedBox(height: 15,),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 15,),
                      SizedBox(height: 6,),
                      Expanded(child: Text('$city, $country')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}