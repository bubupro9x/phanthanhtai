import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  List<ItemModel> items = [
    ItemModel(
        name: 'Chiếc đèn hư',
        price: 5,
        img:
            'https://media.discordapp.net/ephemeral-attachments/1008571127779573780/1083576305016119296/grid_0.webp?width=936&height=936',
        id: 0,
        isEnable: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (items[index].id == 0) {
                    if(items[index].isEnable == false){
                      showPopup(name: items[index].name, price: items[index].price);
                    }else{

                    }
                  }
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Image.network(
                          items[index].img,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          items[index].name,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Coin: ${items[index].price}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    if (items[index].isEnable == false)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey.withOpacity(0.7),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Text(
                            'Mở khóa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showPopup({required String name, required int price}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vật phẩm đang khóa, bạn có muốn mở?'),
          content:  Text('$name\nCoin: ${price.toString()}',style: const TextStyle(fontSize: 18),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Mở khóa'),
            ),
          ],
        );
      },
    );
  }
}

class ItemModel {
  ItemModel(
      {required this.name,
      required this.price,
      required this.img,
      required this.id,
      required this.isEnable});

  String img;
  String name;
  int price;
  int id;
  bool isEnable;
}
