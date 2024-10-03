import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furnimitra/Bloc/FavBloc/favbloc.dart';
import 'package:furnimitra/Provider/Login_provider.dart';
import 'package:furnimitra/Screens/Dashboard.dart';
import 'package:furnimitra/Screens/Login.dart';
import 'package:furnimitra/Screens/Splash_screen.dart';
import 'package:furnimitra/Services/Mongo_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await MongoService.connect(); 
   
  } catch (e) {
    print('Error connecting to MongoDB: $e');
  }
  

  await Firebase.initializeApp(); 

   runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoritesBloc()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), 
    );
  }
}
