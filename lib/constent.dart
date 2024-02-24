// List of constant cars with image URLs from network
import 'package:ecommerc_project/product/domain/entity/car_product_entity.dart';

final List<Car> carList = [
  Car(
    brand: 'Toyota',
    model: 'Camry',
    year: 2020,
    color: 'Red',
    price: 25000,
    imageName : 'https://images.dealer.com/ddc/vehicles/2024/Toyota/Camry/Sedan/trim_LE_4e76be/color/Supersonic%20Red-3U5-162%2C25%2C32-640-en_US.jpg?impolicy=resize&w=414',
  ),
  Car(
    brand: 'Honda',
    model: 'Accord',
    year: 2019,
    color: 'Blue',
    price: 28000,
    imageName : 'https://di-uploads-pod16.dealerinspire.com/pattypeckhonda/uploads/2018/12/Artboard-2019-honda-Accord-sedan-color-Still-Night-Pearl.png',
  ),
  Car(
    brand: 'Ford',
    model: 'Fusion',
    year: 2018,
    color: 'Silver',
    price: 22000,
    imageName : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfP4y1gs06msSTyw2LVxEeOtk3ucf83os2XxQKT1kCrQ&s',
  ),
  // Add more cars
  Car(
    brand: 'Chevrolet',
    model: 'Malibu',
    year: 2017,
    color: 'Black',
    price: 20000,
    imageName : 'https://images.dealer.com/autodata/us/large_stockphoto-color/2017/USC70CHC111E0/GB8.jpg',
  ),
  Car(
    brand: 'BMW',
    model: '3 Series',
    year: 2021,
    color: 'White',
    price: 35000,
    imageName : 'https://stimg.cardekho.com/images/car-images/large/BMW/3-Series-Gran-Limousine/10581/1689769038703/223_Mineral-White_cdcdcb.jpg?impolicy=resize&imwidth=420',
  ),
  Car(
    brand: 'Audi',
    model: 'A4',
    year: 2019,
    color: 'Gray',
    price: 32000,
    imageName : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLq0blj4UuEUooQYU6rIjC5tQIa0Awg8gBn5KZTIODbA&s',
  ),
  Car(
    brand: 'Mercedes-Benz',
    model: 'C-Class',
    year: 2020,
    color: 'Blue',
    price: 38000,
    imageName : 'https://vehicle-images.dealerinspire.com/stock-images/thumbnails/large/chrome/876247e35648d16c7bf4b8213a4689aa.png',
  ),
  Car(
    brand: 'Lexus',
    model: 'ES',
    year: 2019,
    color: 'Red',
    price: 30000,
    imageName : 'https://cars.usnews.com/static/images/Auto/izmo/i102813441/2019_lexus_es_angularfront.jpg',
  ),
  Car(
    brand: 'Hyundai',
    model: 'Sonata',
    year: 2018,
    color: 'Silver',
    price: 21000,
    imageName : 'https://www.motortrend.com/uploads/sites/10/2017/08/2018-hyundai-sonata-sel-sedan-angular-front.png',
  ),
  Car(
    brand: 'Kia',
    model: 'Optima',
    year: 2020,
    color: 'Black',
    price: 24000,
    imageName : 'https://www.motortrend.com/uploads/sites/10/2020/01/2020-kia-optima-lx-sedan-angular-front.png',
  ),
  Car(
    brand: 'Nissan',
    model: 'Altima',
    year: 2019,
    color: 'Blue',
    price: 23000,
    imageName : 'https://ms-prd-nna.use.mediaserver.heliosnissan.net/iris/iris?resp=png&bkgnd=transparent&pov=E01&w=8667&h=8667&x=797&y=222&height=326&width=578&vehicle=8_L34&paint=RAY&fabric=N&brand=nisnna&sa=1_B,2_DB,4_A,5_L,6_S,7_Z,11_D,12_U,13_A,SHADOW_ON,PI_ON,PE_ON,2024',
  ),

];



List<Map<String,dynamic>> carInfo=[
  {
    "carText":'Toyota',

  },
  {
    "carText":'Honda',
  },

  {
    "carText":'Ford',
  },
  {
    "carText":'Chevrolet',
  },
  {
    "carText":'BMW'
  },
  {
    "carText":'Audi'
  },
  {
    "carText":'Mercedes-Benz'
  },
  {
    "carText":'Lexus'
  },
  {
    "carText":'Hyundai'
  },
  {
    "carText":'Kia'
  },
  {
    "carText":'Nissan'
  }

];
