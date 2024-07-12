import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../features.dart';

///
class ProdcutsRepostiory {
  /// Handles C.R.U.D operations on products
  const ProdcutsRepostiory();

  /// Returns list of [Product]
  Future<CustomResponse<List<Product>>> getProducts(Session session) async {
    final Uri url = Uri.parse(
        '$kTimuApiBaseUrl/products?organization_id=$kTimuOrganisationID&size=10');

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Token ${session.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body) as dynamic;
        final List<dynamic> items = data['items'] as List<dynamic>;

        final List<Product> products = List<dynamic>.from(items)
            .map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList();

        return CustomResponse<List<Product>>(value: products);
      } else {
        debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
        return CustomResponse<List<Product>>(error: kSomethingWentWrong);
      }
    } on HttpException catch (e) {
      debugPrint('Error: $e');
      return CustomResponse<List<Product>>(error: kSomethingWentWrong);
    } catch (e) {
      debugPrint('Error: $e');
      return CustomResponse<List<Product>>(error: kSomethingWentWrong);
    }
  }
}

// List<Product> products = <Product>[
//   const Product(
//     id: '1',
//     name: 'Dell xps 16',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://cdn.mos.cms.futurecdn.net/Ajc3ezCTN4FGz2vF4LpQn9-1200-80.jpg',
//     price: 999.99,
//     description:
//         'A high-performance laptop suitable for all your computing needs.',
//   ),
//   const Product(
//     id: '2',
//     name: 'Smartphone',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvmQCnLLbDR-f1_1_GD2yC8dGVG3OZfAkRCQ&s',
//     price: 799.99,
//     description: 'A sleek smartphone with the latest features and technology.',
//   ),
//   const Product(
//     id: '3',
//     name: 'Coffee Maker',
//     catergory: 'Home Appliances',
//     imgUrl:
//         'https://assets.epicurious.com/photos/63fe55ccd42409303d652a40/3:2/w_4998,h_3332,c_limit/DeLonghi_TrueBrew-review-HERO_022323_14264_VOG_final.jpg',
//     price: 49.99,
//     description:
//         'Brew the perfect cup of coffee with this easy-to-use coffee maker.',
//   ),
//   const Product(
//     id: '4',
//     name: 'Headphones',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcGYtczczLXBhaS0xNTgta2FuYXRlLTAxLW1vY2t1cF8xLmpwZw.jpg',
//     price: 199.99,
//     description:
//         'Experience immersive sound with these high-quality headphones.',
//   ),
//   const Product(
//     id: '5',
//     name: 'Desk Chair',
//     catergory: 'Furniture',
//     imgUrl: 'https://m.media-amazon.com/images/I/81PLFSsIXjL._AC_SL1500_.jpg',
//     price: 149.99,
//     description: 'A comfortable and ergonomic desk chair for your home office.',
//   ),
//   const Product(
//     id: '6',
//     name: 'Blender',
//     catergory: 'Home Appliances',
//     imgUrl:
//         'https://contentgrid.homedepot-static.com/hdus/en_US/DTCCOMNEW/Articles/best-blenders-for-your-kitchen-2022-section-1.jpg',
//     price: 89.99,
//     description:
//         'Blend your favorite smoothies and soups with this powerful blender.',
//   ),
//   const Product(
//     id: '7',
//     name: 'Running Shoes',
//     catergory: 'Sportswear',
//     imgUrl:
//         'https://www.verywellfit.com/thmb/bynyAnp5S2lpJzy8Lag4vRb3fsY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/running-shoes-vs-walking-shoes-3436331-0251-54aa872527134b569d8ba4ae0b7e3b27.jpg',
//     price: 120.00,
//     description:
//         'High-quality running shoes for maximum comfort and performance.',
//   ),
//   const Product(
//     id: '8',
//     name: 'Watch',
//     catergory: 'Accessories',
//     imgUrl:
//         'https://st.depositphotos.com/2288675/2450/i/450/depositphotos_24503275-stock-photo-gold-pocket-watch-and-hourglass.jpg',
//     price: 250.00,
//     description:
//         'A stylish watch to complement your outfit and keep you on time.',
//   ),
//   const Product(
//     id: '9',
//     name: 'Backpack',
//     catergory: 'Accessories',
//     imgUrl:
//         'https://media.wired.com/photos/5b72139a4177c301e3b9b193/master/pass/Jansport_05.jpg',
//     price: 89.99,
//     description: 'A durable and spacious backpack for all your essentials.',
//   ),
//   const Product(
//     id: '10',
//     name: 'Desk Lamp',
//     catergory: 'Furniture',
//     imgUrl: 'https://m.media-amazon.com/images/I/61LqZYRmACS._AC_SL1500_.jpg',
//     price: 35.99,
//     description: 'A sleek desk lamp to brighten your workspace.',
//   ),
//   const Product(
//     id: '11',
//     name: 'Electric Kettle',
//     catergory: 'Home Appliances',
//     imgUrl:
//         'https://www-konga-com-res.cloudinary.com/w_400,f_auto,fl_lossy,dpr_3.0,q_auto/media/catalog/product/E/l/Electric-Kettle---4-2-Litre-7844944_1.jpg',
//     price: 29.99,
//     description:
//         'Boil water quickly and efficiently with this electric kettle.',
//   ),
//   const Product(
//     id: '12',
//     name: 'Tablet',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1FxjFGjxYx1dRBnX5WMta9lsaQ1lV-RFnHA&s',
//     price: 499.99,
//     description:
//         'A versatile tablet for work, play, and everything in between.',
//   ),
//   const Product(
//     id: '13',
//     name: 'Gaming Console',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://www.verywellfamily.com/thmb/2wXcrTX8jGusCTarMrQ2RBGs5Xg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/best-video-game-consoles-for-kids-6754397-4a3970c4de8e4bb78ff7cafa89a99b7c.jpg',
//     price: 399.99,
//     description: 'Enjoy endless gaming fun with this popular gaming console.',
//   ),
//   const Product(
//     id: '14',
//     name: 'Electric Toothbrush',
//     catergory: 'Health & Beauty',
//     imgUrl:
//         'https://static.beautytocare.com/cdn-cgi/image/width=1600,height=1600,f=auto/media/catalog/product//o/r/oral-b-vitality-pro-protect-x-clean-box-electric-toothbrush-lilac-mist.jpg',
//     price: 59.99,
//     description:
//         'Keep your teeth clean and healthy with this electric toothbrush.',
//   ),
//   const Product(
//     id: '15',
//     name: 'Digital Camera',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://cameratrader.ng/wp-content/uploads/2020/12/Sony-ZV-1-Digital-Camera.-.jpeg',
//     price: 599.99,
//     description: 'Capture stunning photos and videos with this digital camera.',
//   ),
//   const Product(
//     id: '16',
//     name: 'Yoga Mat',
//     catergory: 'Sportswear',
//     imgUrl: 'https://www.gaiam.com/cdn/shop/articles/19.jpg?v=1492018692',
//     price: 20.00,
//     description: 'A comfortable yoga mat for all your yoga and exercise needs.',
//   ),
//   const Product(
//     id: '17',
//     name: 'Desk Organizer',
//     catergory: 'Furniture',
//     imgUrl:
//         'https://m.media-amazon.com/images/I/41VnGJsIhgL._AC_UF1000,1000_QL80_.jpg',
//     price: 25.99,
//     description: 'Keep your desk tidy with this functional desk organizer.',
//   ),
//   const Product(
//     id: '18',
//     name: 'Wireless Mouse',
//     catergory: 'Electronics',
//     imgUrl: 'https://m.media-amazon.com/images/I/61nde-uGu1L._AC_SL1200_.jpg',
//     price: 29.99,
//     description: 'A smooth and responsive wireless mouse for your computer.',
//   ),
//   const Product(
//     id: '19',
//     name: 'Bluetooth Speaker',
//     catergory: 'Electronics',
//     imgUrl:
//         'https://www.portronics.com/cdn/shop/products/1200x1200-1_f9603141-7702-46be-bea0-4dbe05a1086b_large.jpg?v=1666346127',
//     price: 49.99,
//     description:
//         'Enjoy your music anywhere with this portable Bluetooth speaker.',
//   ),
//   const Product(
//     id: '20',
//     name: 'Sunglasses',
//     catergory: 'Accessories',
//     imgUrl:
//         'https://ng.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/48/9255722/1.jpg?7307',
//     price: 99.99,
//     description:
//         'Protect your eyes from the sun with these stylish sunglasses.',
//   ),
// ];
