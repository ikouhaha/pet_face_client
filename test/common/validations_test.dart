
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/common/validations.dart';

void main() {
  test("test validateEmail correct", () {
    String value = "ikouhaha888@gmail.com";
    expect(Validations.validateEmail(value), isNull);
  });

  test("test validateEmail empty", () {
    String value = "";
    expect(Validations.validateEmail(value), "Please fill the email field");
  });
  test("test validateEmail error", () {
    String value = "ikouhaha888gmail.com";
    expect(Validations.validateEmail(value), "Please enter a valid email");
  });
   test("test validateName correct", () {
    String value = "ikouhaha";
    expect(Validations.validateName(value), isNull);
  });
   test("test validateName empty", () {
    String value = "";
    expect(Validations.validateName(value), "Please fill the name field");
  });

  test("test validateName error", () {
    String value = "ikouhaha888@gmail.com";
    expect(Validations.validateName(value), "Please enter a valid name");
  });

  test("test validatePassword correct", () {
    String value = "abcxyz123";
    expect(Validations.validatePassword(value), isNull);
  });
  test("test validatePassword empty", () {
    String value = "";
    expect(Validations.validatePassword(value), "Please fill the password field");
  });
  test("test validatePassword error", () {
    String value = "12345";
    expect(Validations.validatePassword(value), "Minimum eight characters, at least one letter and one number");
  });
  
  
  test("test validateText correct", () {
    String value = "abcxyz123";
    expect(Validations.validateText(value), isNull);
  });

  test("test validateText empty", () {
    String value = "";
    expect(Validations.validateText(value), "Please fill the field");
  });

  test("test validateInt correct", () {
    int value = 123;
    expect(Validations.validateInt(value), isNull);
  });

  test("test validateInt empty", () {
    int? value = null;
    expect(Validations.validateInt(value), "Please fill the field");
  });

  test("test validateConfirmPassword correct", () {
    String pwd = "abcxyz123";
    String value = "abcxyz123";
    expect(Validations.validateConfirmPassword(pwd, value), isNull);
  });

  test("test validateConfirmPassword empty", () {
    String pwd = "abcxyz123";
    String value = "";
    expect(Validations.validateConfirmPassword(pwd, value), "Please fill the confirm password field");
  });

   test("test validateConfirmPassword incorrect", () {
    String pwd = "abcxyz123";
    String value = "1";
    expect(Validations.validateConfirmPassword(pwd, value), "Please match with password");
  });
}
