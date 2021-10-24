import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class BaiTap extends StatelessWidget {
  const BaiTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage5(),
    );
  }
}
class HomePage5 extends StatefulWidget {
  const HomePage5({Key? key}) : super(key: key);

  @override
  _HomePage5State createState() => _HomePage5State();
}

class _HomePage5State extends State<HomePage5> {
  late Future<List<Product>> lsProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsProduct =Product.fetchData();
  }

  @override
  Widget build(BuildContext context) { return Scaffold(
    body: FutureBuilder(
        future: lsProduct,
        builder: (BuildContext,AsyncSnapshot<dynamic> snapshot){
          if(snapshot.hasData){
            List<Product> data=snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  var pro =data[index];
                  return ListTile(
                      leading: Image.network(pro.image),
                      title: Text(pro.title)
                  );
                });
          }
          else
            return Center( child:CircularProgressIndicator());
        }
    ),
  );
  }

}
List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Product{


  final int id;
  final String title;
  final double price;
  final String description;
  final Category category;
  final String image;
  final Rating rating;

  Product( this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating,);

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    price: json["price"].toDouble(),
    description: json["description"],
    category: categoryValues.map[json["category"]],
    image: json["image"],
    rating: Rating.fromJson(json["rating"]),
  );
  

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": categoryValues.reverse[category],
    "image": image,
    "rating": rating.toJson(),
  };

  static Future<List<Product>> fetchData() async {
    String url="https://fakestoreapi.com/products";
    var client =http.Client();
    client.get(Uri.parse(url));
    var response=await client.get(Uri.parse(url));
    if(response.statusCode==200){
      var result =response.body;
      var jsonData=jsonDecode(result);
      List<Product> lsProduct=[];
      for(var item in jsonData){
        print(item);
        var id = item['id'];
        var title= item['title'];
        var price=item['price'];
        var description= item['description'];
        var category=item['category'];
        var image=item['image'];
        var rating=item['rating'];
        Product p = new Product(id, title, price, description, category, image, rating);
        lsProduct.add(p);
      }
      return lsProduct;
    }else{
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }

  }

}
enum Category { MEN_S_CLOTHING, JEWELERY, ELECTRONICS, WOMEN_S_CLOTHING }

final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING
});
class Rating {
  Rating({
    this.rate,
    this.count,
  });

  final double rate;
  final int count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    rate: json["rate"].toDouble(),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "rate": rate,
    "count": count,
  };
}
