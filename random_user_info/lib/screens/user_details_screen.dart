import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget{
  const UserDetailsScreen({super.key, required this.user, required this.id, required this.favorites, required this.onToggle});

  final Map<String, dynamic> user;
  final String id;
  final Set<String> favorites;
  final ValueChanged<String> onToggle;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.favorites.contains(widget.id);
  }

  void _handleToggle(){
    setState(() {
      _isFav = !_isFav;
    });
    widget.onToggle(widget.id);    // telling homescreen to update favorite set
  }

  @override
  Widget build(BuildContext context) {
    final name = '${widget.user['name']['first']} ${widget.user['name']['last']}';
    final age = '${widget.user['dob']['age']}';
    final city = '${widget.user['location']['city']}';
    final country = '${widget.user['location']['country']}';
    final image = widget.user['picture']['large'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: [
          IconButton(
            onPressed: _handleToggle,
            icon: widget.favorites.contains(widget.id)
                  ? Icon(Icons.favorite, color: Colors.red,)
                  : Icon(Icons.favorite_border, color: Colors.black,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.id,
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