import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:zenciti/app/routes.dart';
import 'package:zenciti/features/auth/data/api/api_client.dart';
import 'dart:convert';

import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/login_use_case.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
            // apiClient: ApiClient(baseUrl: "http://172.20.10.5:8080"),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              LoginUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
          // BlocProvider(
          //     create: (context) => LoginBloc(LoginUseCase(context.read()))),
          BlocProvider(
            create: (context) => SignUpBloc(
              RegisterUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
          // BlocProvider(create: (_) => AuthenticationBloc()),
          // BlocProvider(create: (_) => NavigationBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'Kadwa',
          ),
          // onGenerateRoute: NavigationBloc.router.onGenerateRoute,
          home: LoginScreen(),
        ),
      ),
    );
  }
}
// void main() { runApp(MyApp()); } class MyApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( home: TableMapScreen(),); } } class TableModel { final int id; final String name; final double x, y; bool reserved; TableModel({ required this.id, required this.name, required this.x, required this.y, required this.reserved, }); factory TableModel.fromJson(Map<String, dynamic> json) { return TableModel( id: json['id'], name: json['name'], x: json['x'], y: json['y'], reserved: json['reserved'],); } } class TableMapScreen extends StatefulWidget { @override _TableMapScreenState createState() => _TableMapScreenState(); } class _TableMapScreenState extends State<TableMapScreen> { List<TableModel> tables = []; @override void initState() { super.initState(); fetchTables(); } Future<void> fetchTables() async { final response = await http.get(Uri.parse('http://localhost:8080/tables')); print(table.reserved ? 'assets/images/table_availble.svg' : 'assets/images/table_reserved.svg'); if (response.statusCode == 200) { List<dynamic> data = jsonDecode(response.body); setState(() { tables = data.map((table) => TableModel.fromJson(table)).toList(); }); } } Future<void> reserveTable(TableModel table) async { table.reserved = !table.reserved; await http.post( Uri.parse('http://localhost:8080/table'), Uri.parse('http://localhost:8080/table'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({ 'id': table.id, 'reserved': table.reserved, }),); setState(() {}); print(table.reserved ? 'assets/images/table_availble.svg' : 'assets/images/table_reserved.svg'); } @override Widget build(BuildContext context) { print(table.reserved ? 'assets/images/table_availble.svg' : 'assets/images/table_reserved.svg'); return Scaffold( appBar: AppBar(title: Text('Restaurant Map')), body: Stack( children: tables.map((table) { return Positioned( left: table.x, top: table.y, child: GestureDetector( onTap: () { print(table.reserved ? 'assets/images/table_available.svg' : 'assets/images/table_reserved.svg'); reserveTable(table); }, child: SvgPicture.asset( table.reserved ? 'assets/images/table_availble.svg' : 'assets/images/table_reserved.svg', width: 80, height: 80,)),); }).toList(),),);/*   */}
