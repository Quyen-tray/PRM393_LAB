// TODO 1: Định nghĩa class Vehicle với các thuộc tính String brand, int year.
// Viết Default constructor và hàm void startEngine().
class Vehicle {
  String brand;
  int year;

  // Default constructor
  Vehicle(this.brand, this.year);

  void startEngine() {
    print('Khởi động phương tiện...');
  }
}

// TODO 2: Định nghĩa class Car kế thừa từ Vehicle.
// Thêm thuộc tính bool isElectric.
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Viết constructor mặc định cho Car (dùng super để truyền brand và year).
  Car(String brand, int year, this.isElectric) : super(brand, year);

  // Named Constructor: Car.tesla(int year) thiết lập sẵn brand="Tesla" và isElectric=true.
  // Lưu ý: không thể viết "this.year" ở đây vì year là thuộc tính được
  // khai báo ở lớp cha (Vehicle), không phải ở Car - cú pháp "this.x" chỉ
  // dùng được cho thuộc tính khai báo ngay trong lớp hiện tại. Vì vậy ta
  // nhận year như một tham số bình thường rồi truyền lên super().
  Car.tesla(int year)
      : isElectric = true,
        super('Tesla', year);

  // TODO 4: Ghi đè (@override) hàm startEngine() để in ra thông báo chi tiết hơn.
  @override
  void startEngine() {
    if (isElectric) {
      print('$brand ($year): động cơ điện khởi động êm ái - Vù...vù (không tiếng ồn)');
    } else {
      print('$brand ($year): động cơ xăng khởi động - Gầm rú Brừm...Brừm!');
    }
  }
}

void main() {
  // TODO 5: Khởi tạo một xe Car bình thường và gọi startEngine()
  Car gasCar = Car('Toyota', 2020, false);
  gasCar.startEngine();

  // TODO 6: Khởi tạo một xe Car bằng Named Constructor (Car.tesla) và gọi startEngine()
  Car teslaCar = Car.tesla(2024);
  teslaCar.startEngine();
}