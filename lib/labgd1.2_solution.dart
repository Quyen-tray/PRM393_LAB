abstract class Employee {
  String name;
  Employee(this.name);
  void work();
}

// TODO 1: Khai báo mixin CheckInAbility giới hạn cho Employee
// "on Employee" đảm bảo mixin này chỉ áp dụng được cho các lớp
// kế thừa (hoặc là) Employee, vì bên trong mixin ta cần truy cập
// thuộc tính "name" vốn chỉ tồn tại trên Employee.
mixin CheckInAbility on Employee {
  void checkIn() {
    print('$name đã điểm danh');
  }
}

class Developer extends Employee
// TODO 2: Tích hợp mixin CheckInAbility vào class này
    with CheckInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print("$name đang viết code.");
}

void main() {
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];

  // TODO 3: Dùng Spread Operator (...) để gộp teamA và teamB vào allStaff
  List<Developer> allStaff = [...teamA, ...teamB];

  // TODO 4: Dùng vòng lặp gọi hàm checkIn() cho tất cả nhân sự trong allStaff
  for (Developer staff in allStaff) {
    staff.checkIn();
  }
}