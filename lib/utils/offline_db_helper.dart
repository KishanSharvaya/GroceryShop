import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbHelper {
  static OfflineDbHelper _offlineDbHelper;
  static Database database;

  static const TABLE_PRODUCT_CART = "product_cart";


/*  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
      join(await getDatabasesPath(), 'soleoserp_database.db'),
      onCreate: (db, version) {
        return db.execute(


          'CREATE TABLE $TABLE_CONTACTS(id INTEGER PRIMARY KEY AUTOINCREMENT, pkId TEXT,CustomerID TEXT, ContactDesignationName TEXT, ContactDesigCode1 TEXT, CompanyId TEXT, ContactPerson1 TEXT, ContactNumber1 TEXT, ContactEmail1 TEXT, LoginUserID TEXT)',
         // 'CREATE TABLE $TABLE_INQUIRY_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InquiryNo TEXT,LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, Quantity TEXT, UnitPrice TEXT)',

        );

      },
      version: 2,
    );
  }*/

  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
        join(await getDatabasesPath(), 'grocery_database.db'),
        onCreate: (db, version) =>_createDb(db),version: 4
    );
  }

  static void _createDb(Database db) {


    /* int id;
  final String name;
  final String description;
  final double price;
  final String Nutritions;
  final String imagePath;*/

    db.execute('CREATE TABLE $TABLE_PRODUCT_CART(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,description TEXT, price DOUBLE, Qty INTEGER , Nutritions TEXT, imagePath TEXT)',);


  }

  static OfflineDbHelper getInstance() {
    return _offlineDbHelper;
  }

  ///Here Customer Contact Table Implimentation


  Future<int> insertProductToCart(ProductCartModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_PRODUCT_CART,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductCartModel>> getProductCartList() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_PRODUCT_CART);

    return List.generate(maps.length, (i) {


      return ProductCartModel(
        maps[i]['name'],
        maps[i]['description'],
        maps[i]['price'],
        maps[i]['Qty'],
        maps[i]['Nutritions'],
        maps[i]['imagePath'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateContact(ProductCartModel model) async {
    final db = await database;

    await db.update(
      TABLE_PRODUCT_CART,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await database;

    await db.delete(
      TABLE_PRODUCT_CART,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteContactTable() async {
    final db = await database;

    await db.delete(
        TABLE_PRODUCT_CART
    );
  }




}
