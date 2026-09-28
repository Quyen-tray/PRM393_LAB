class User {
  int id;
  String name;
  // TODO 1: Khai báo biến email có thể mang giá trị null (nullable variable)
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // TODO 2: Khai báo factory User.fromJson(Map<String, dynamic> json)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      // Nếu json['name'] bị thiếu hoặc null thì dùng "Khách" làm mặc định
      name: (json['name'] as String?) ?? 'Khách',
      // email vốn cho phép null nên gán thẳng
      email: json['email'] as String?,
    );
  }

  void showProfile() {
    // TODO 3: Dùng ?? để hiển thị "Chưa cập nhật" nếu email bị null
    print('ID: $id | Tên: $name | Email: ${email ?? 'Chưa cập nhật'}');
  }
}

void main() {
  // Giả lập dữ liệu JSON trả về từ API
  Map<String, dynamic> rawData1 = {"id": 1, "name": "Nam", "email": "nam@fpt.edu.vn"};
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  // TODO 4: Khởi tạo user1 và user2 từ 2 Map trên bằng User.fromJson() và gọi showProfile()
  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}