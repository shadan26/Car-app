// List of constant cars with image URLs from network
import 'dart:ui';

import 'package:ecommerc_project/core/Firebase/FirebaseManager.dart';
import 'package:ecommerc_project/product/domain/entity/car_product_entity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
const kPrimaryColor=Color(0xff365b6d);


// class NotificationListenerProvider {
//   final  _firebaseMessaging = FirebaseMessaging.instance.getInitialMessage();
//   void getMessage() {
//     var notification;
//     print("::::::::::::::::::::::::::::::::::$notification");
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       RemoteNotification notification = event.notification!;
//       AndroidNotification androidNotification = event.notification!.android!;
//
//       if (notification != null && androidNotification != null) {
//         FirebaseManager().sendNotification(title: notification.title!, body: notification.body!);
//       }
//     });
//   }
//
// }

// final List<Car> carList = [
//   Car(
//       brand: 'Toyota',
//       model: 'Camry',
//       year: 2020,
//       color: 'Red',
//       price: 25000,
//       imageName:
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjVIb8XJj78KlJbwvEaiHxXLh9xdgrOfto7XrWOr6c5Q&s',
//       desecription:
//           'The Toyota Camry is a popular mid-size sedan known for its reliability, comfort, and fuel efficiency. The 2020 model typically offers a sleek design, spacious interior, advanced safety features, and a smooth ride. With its stylish appearance and practicality, the Toyota Camry is a favorite choice among drivers seeking a dependable and comfortable vehicle for daily commuting or family transportation.',
//       callMe: " 078011875", description: '', id: 2 ),
//   Car(
//       brand: 'Toyota',
//       model: 'Corolla',
//       year: 2021,
//       color: 'Blue',
//       price: 22000,
//       imageName:
//           'https://di-uploads-pod14.dealerinspire.com/oaklawntoyota/uploads/2020/08/2021-Toyota-Corolla-in-Blueprint.png',
//       desecription:
//           'The Toyota Corolla is a compact sedan known for its reliability, fuel efficiency, and affordability. As one of the best-selling cars globally, the Corolla offers a comfortable ride, spacious interior, and advanced safety features. With its sleek design and reputation for longevity, the Corolla is a popular choice for commuters, families, and first-time car buyers alike',
//       callMe: " 0777658498 ", description: '', id: 2),
//   Car(
//       brand: 'Toyota',
//       model: 'RAV4',
//       year: 2022,
//       color: 'Black',
//       price: 28000,
//       imageName:
//           'https://carsguide-res.cloudinary.com/image/upload/f_auto,fl_lossy,q_auto,t_cg_hero_low/v1/editorial/vhs/rav4-2021.png',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Toyota',
//       model: 'Highlander',
//       year: 2023,
//       color: 'Silver',
//       price: 35000,
//       imageName:
//           'https://edgecast-img.yahoo.net/mysterio/api/B0243CE664CC93C385F6829BFC50692F44AF46FDBC76275012170C4C3B66EBAB/autoblog/resizefill_w788_h525;quality_80;format_webp;cc_31536000;/https://s.aolcdn.com/commerce/autodata/images/USD30TOS142E021001.jpg',
//       desecription:
//           'The Toyota RAV4 is a compact crossover SUV known for its versatility, reliability, and advanced features. It offers a spacious interior, comfortable ride, and ample cargo space, making it suitable for both city driving and outdoor adventures. With its sleek and modern design, the RAV4 appeals to a wide range of drivers looking for a practical yet stylish vehicle',
//       callMe: " 0789876543", description: '', id: 2),
//   Car(
//       brand: 'Toyota',
//       model: 'Sienna',
//       year: 2022,
//       color: 'White',
//       price: 40000,
//       imageName:
//           'https://www.edmunds.com/assets/m/for-sale/29-5tdjskfc7rs122053/img-1-600x400.jpg',
//       desecription:
//           'The Toyota Sienna is a minivan known for its spacious and versatile interior, comfortable ride, and advanced features. As a family-friendly vehicle, the Sienna offers ample seating for up to eight passengers, along with configurable seating arrangements and generous cargo space. It is equipped with a range of convenience and safety features ',
//       callMe: " 07895543245 ", description: '', id: 2),
//   Car(
//       brand: 'Honda',
//       model: 'Accord',
//       year: 2019,
//       color: 'Blue',
//       price: 28000,
//       imageName:
//           'https://di-uploads-pod16.dealerinspire.com/pattypeckhonda/uploads/2018/12/Artboard-2019-honda-Accord-sedan-color-Still-Night-Pearl.png',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Honda',
//       model: 'CR-V',
//       year: 2021,
//       color: 'Silver',
//       price: 32000,
//       imageName:
//           'https://ymimg1.b8cdn.com/resized/car_version/19776/pictures/6971655/webp_listing_main_14317_st1280_046.webp',
//       desecription:
//           'The Honda Accord is a mid-size sedan known for its reliability, comfort, and excellent fuel efficiency. It offers a spacious and well-designed interior, smooth ride quality, and a wide range of advanced features. The 2019 model year Accord may include various trim levels, engine options, and technology packages to suit different preferences and needs.',
//       callMe: "0789756345 ", description: '', id: 2),
//   Car(
//       brand: 'Honda',
//       model: 'Pilot',
//       year: 2018,
//       color: 'Black',
//       price: 35000,
//       imageName:
//           'https://edgecast-img.yahoo.net/mysterio/api/74EE399887B689B9E4D68A68B2CD0BC6AE12A376CFE315C02DFCFAF9F65E7FE4/autoblog/resizefill_w788_h525;quality_80;format_webp;cc_31536000;/https://s.aolcdn.com/commerce/autodata/images/USC80HOS031A021001.jpg',
//       desecription:
//           'The Honda Pilot is a mid-size SUV known for its spacious and versatile interior, comfortable ride, and robust performance. It offers seating for up to eight passengers across three rows, along with ample cargo space and configurable seating arrangements to accommodate various passenger and cargo needs. The 2018 model year Pilot may come equipped with advanced safety features.',
//       callMe: "0789654789 ", description: '', id: 2),
//   Car(
//       brand: 'Honda',
//       model: 'HR-V',
//       year: 2022,
//       color: 'Red',
//       price: 28000,
//       imageName:
//           'https://cdn-fastly.thetruthaboutcars.com/media/2022/07/10/8878983/the-right-spec-2022-honda-hr-v.jpg?size=720x845&nocrop=1',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Ford',
//       model: 'Fusion',
//       year: 2018,
//       color: 'Silver',
//       price: 22000,
//       imageName:
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfP4y1gs06msSTyw2LVxEeOtk3ucf83os2XxQKT1kCrQ&s',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Ford',
//       model: 'Escape',
//       year: 2021,
//       color: 'Blue',
//       price: 28000,
//       imageName:
//           'https://di-uploads-pod39.dealerinspire.com/faricyfordco/uploads/2020/11/2020-Ford-Escape-Model-Left-728x400.jpg',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Ford',
//       model: 'Mustang',
//       year: 2020,
//       color: 'Red',
//       price: 35000,
//       imageName:
//           'https://di-uploads-pod41.dealerinspire.com/andersonfordofclinton/uploads/2019/09/2020-Ford-Mustang-MLP-Hero.png',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Chevrolet',
//       model: 'Malibu',
//       year: 2017,
//       color: 'Black',
//       price: 20000,
//       imageName:
//           'https://images.dealer.com/autodata/us/large_stockphoto-color/2017/USC70CHC111E0/GB8.jpg',
//       desecription:
//           'The Ford Mustang is an iconic sports car known for its powerful performance, stylish design, and rich heritage. It offers a thrilling driving experience with its range of potent engine options, responsive handling,',
//       callMe: "07895324213", description: '', id: 2),
//   Car(
//       brand: 'Chevrolet',
//       model: 'Cruze',
//       year: 2019,
//       color: 'White',
//       price: 22000,
//       imageName:
//           'https://file.kelleybluebookimages.com/kbb/base/evox/CP/13354/2019-Chevrolet-Cruze-front_13354_032_2400x1800_GAZ.png',
//       desecription:
//           'The Chevrolet Cruze is a compact car known for its fuel efficiency, comfortable ride, and modern features. It offers a spacious interior with ample seating and cargo space, making it suitable for both daily commuting and longer trips. The 2019 model year Cruze may come equipped with advanced technology features ',
//       callMe: "0780901293 ", description: '', id: 2),
//   Car(
//       brand: 'BMW',
//       model: '3 Series',
//       year: 2021,
//       color: 'White',
//       price: 35000,
//       imageName:
//           'https://stimg.cardekho.com/images/car-images/large/BMW/3-Series-Gran-Limousine/10581/1689769038703/223_Mineral-White_cdcdcb.jpg?impolicy=resize&imwidth=420',
//       desecription:
//           'The BMW 3 Series is a compact luxury sedan known for its sporty performance, elegant design, and advanced technology features. It offers a dynamic driving experience with responsive handling, powerful engine options, and a well-tuned suspension system. The 2021 model year 3 Series may come equipped with a range of premium amenities,',
//       callMe: " 0789085939", description: '', id: 2),
//   Car(
//       brand: 'Audi',
//       model: 'A4',
//       year: 2019,
//       color: 'Gray',
//       price: 32000,
//       imageName:
//           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLq0blj4UuEUooQYU6rIjC5tQIa0Awg8gBn5KZTIODbA&s',
//       desecription: '',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Mercedes-Benz',
//       model: 'C-Class',
//       year: 2020,
//       color: 'Blue',
//       price: 38000,
//       imageName:
//           'https://vehicle-images.dealerinspire.com/stock-images/thumbnails/large/chrome/876247e35648d16c7bf4b8213a4689aa.png',
//       desecription:
//           'The Audi A4 is a compact luxury sedan known for its refined interior, sophisticated design, and advanced technology features. It offers a comfortable and spacious cabin with high-quality materials and ergonomic controls, providing a premium driving experience. The 2019 model year A4 may feature a range of engine options',
//       callMe: " ", description: '', id: 2),
//   Car(
//       brand: 'Lexus',
//       model: 'ES',
//       year: 2019,
//       color: 'Red',
//       price: 30000,
//       imageName:
//           'https://cars.usnews.com/static/images/Auto/izmo/i102813441/2019_lexus_es_angularfront.jpg',
//       desecription:
//           'The Lexus ES is a luxury sedan known for its refined craftsmanship, comfortable ride, and advanced technology features. It offers a spacious and upscale interior with high-quality materials and attention to detail, providing a serene driving environment. The 2019 model year ES may feature a range of amenities, ',
//       callMe: "078899578 ", description: '', id: 2),
//   Car(
//       brand: 'Hyundai',
//       model: 'Sonata',
//       year: 2018,
//       color: 'Silver',
//       price: 21000,
//       imageName:
//           'https://www.motortrend.com/uploads/sites/10/2017/08/2018-hyundai-sonata-sel-sedan-angular-front.png',
//       desecription:
//           'The Hyundai Sonata is a mid-size sedan known for its practicality, value, and modern features. It offers a comfortable and spacious interior with user-friendly technology and ample cargo space, making it a versatile choice for daily commuting and family outings. The 2018 model year Sonata may come equipped with a range of amenities',
//       callMe: " 07859493934", description: '', id: 1),
//   Car(
//       brand: 'Kia',
//       model: 'Optima',
//       year: 2020,
//       color: 'Black',
//       price: 24000,
//       imageName:
//           'https://www.motortrend.com/uploads/sites/10/2020/01/2020-kia-optima-lx-sedan-angular-front.png',
//       desecription:
//           'The Kia Optima is a mid-size sedan known for its stylish design, spacious interior, and affordable price. It offers a comfortable ride and a range of standard and available features, making it a competitive option in its segment',
//       callMe: " 07879489393", description: '', id: 1),
//   Car(
//       brand: 'Nissan',
//       model: 'Altima',
//       year: 2019,
//       color: 'Blue',
//       price: 23000,
//       imageName:
//           'https://ms-prd-nna.use.mediaserver.heliosnissan.net/iris/iris?resp=png&bkgnd=transparent&pov=E01&w=8667&h=8667&x=797&y=222&height=326&width=578&vehicle=8_L34&paint=RAY&fabric=N&brand=nisnna&sa=1_B,2_DB,4_A,5_L,6_S,7_Z,11_D,12_U,13_A,SHADOW_ON,PI_ON,PE_ON,2024',
//       desecription:
//           'The Nissan Altima is a mid-size sedan known for its fuel efficiency, comfortable ride, and spacious interior. It offers a range of engine options, including efficient four-cylinder engines and available all-wheel drive for enhanced traction in various driving conditions. ',
//       callMe: " 0785932392", description: '', id: 1),
// ];
//
List<Map<String, dynamic>> carInfo = [
  {
    "carText": 'Toyota',
  },
  {
    "carText": 'Honda',
  },
  {
    "carText": 'Ford',
  },
  {
    "carText": 'Chevrolet',
  },
  {"carText": 'BMW'},
  {"carText": 'Audi'},
  {"carText": 'Mercedes-Benz'},
  {"carText": 'Lexus'},
  {"carText": 'Hyundai'},
  {"carText": 'Kia'},
  {"carText": 'Nissan'}
];
