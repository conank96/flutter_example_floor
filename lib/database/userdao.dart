
import 'package:floor/floor.dart';
import 'package:sqlite_demo/database/user_entity.dart';

const String user_table_name = "User_TABLE";

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Stream<List<User>> getAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> findUserNameByID(int id);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(User user);

  @Query('DELETE FROM User')
  Future<void> deleteUser();

  @Query('DELETE FROM User WHERE id = :id')
  Future<void> deleteUserByID(int id);

  @insert
  Future<void> addUser(User user);
}
