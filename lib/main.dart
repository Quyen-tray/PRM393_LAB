import 'package:flutter/material.dart';

/// Lab 7 – Signup Form with Validation & Good UX
/// Toàn bộ demo nằm trong 1 file để có thể dán vào DartPad.
///  - Lab 7.1: Form + TextFormField + Submit
///  - Lab 7.2: Validation rules & password strength
///  - Lab 7.3: Focus & keyboard management
///  - Lab 7.4: Async email check (giả lập)

void main() => runApp(const SignupApp());

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const SignupScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// VALIDATORS (tách riêng khỏi UI cho code sạch, dễ test)
// ---------------------------------------------------------------------------

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name is required';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final v = value.trim();
  // Tối thiểu phải có "@" và "." theo đúng yêu cầu đề bài,
  // thêm kiểm tra "." nằm sau "@" để chặt chẽ hơn.
  final at = v.indexOf('@');
  if (at < 1 || !v.substring(at).contains('.') || v.endsWith('.')) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least 1 digit';
  }
  return null;
}

/// Confirm password cần biết giá trị password nên nhận thêm tham số.
String? validateConfirm(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

/// Đánh giá độ mạnh mật khẩu: 0 = trống, 1 = Weak, 2 = Medium, 3 = Strong.
int passwordStrength(String p) {
  if (p.isEmpty) return 0;
  int score = 0;
  if (p.length >= 8) score++;
  if (RegExp(r'[0-9]').hasMatch(p)) score++;
  if (RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p)) score++;
  if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
  if (score <= 1) return 1;
  if (score == 2 || score == 3) return 2;
  return 3;
}

// ---------------------------------------------------------------------------
// SIGNUP SCREEN
// ---------------------------------------------------------------------------

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Khóa để truy cập FormState (validate / save)
  final _formKey = GlobalKey<FormState>();
  // Khóa riêng cho ô confirm để validate lại khi password đổi
  final _confirmKey = GlobalKey<FormFieldState<String>>();

  // Controllers: đọc giá trị password hiện tại để so sánh confirm
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // FocusNode cho từng ô (Lab 7.3)
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // Dữ liệu lưu qua onSaved
  String _name = '';
  String _email = '';

  bool _obscurePassword = true; // bonus: show/hide password
  bool _obscureConfirm = true;
  bool _acceptedTerms = false; // bonus: terms & conditions
  bool _isCheckingEmail = false; // Lab 7.4: đang kiểm tra email

  @override
  void initState() {
    super.initState();
    // Cập nhật thanh độ mạnh mật khẩu khi người dùng gõ
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  /// Gửi form: validate đồng bộ -> kiểm tra email async -> báo thành công.
  Future<void> _submit() async {
    // Chặn gửi lặp khi đang kiểm tra
    if (_isCheckingEmail) return;

    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    // 1. Validate đồng bộ: sai thì dừng, lỗi hiện dưới từng ô
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    // 2. Lab 7.4: kiểm tra email bất đồng bộ (giả lập API)
    setState(() => _isCheckingEmail = true);
    await Future.delayed(const Duration(seconds: 2));
    final taken = _email.toLowerCase().startsWith('taken');

    // Widget có thể đã bị đóng trong lúc chờ
    if (!mounted) return;
    setState(() => _isCheckingEmail = false);

    if (taken) {
      _showSnackBar('This email is already taken', isError: true);
      _emailFocus.requestFocus();
      return;
    }

    // 3. Thành công
    _showSnackBar('Account created for $_name 🎉');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // Chạm ra ngoài để ẩn bàn phím (Lab 7.3)
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              // Hiện lỗi ngay khi người dùng tương tác với ô
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // ListView giúp cuộn được, tránh overflow khi bàn phím mở
              child: ListView(
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 8),
                  _buildStrengthIndicator(),
                  const SizedBox(height: 16),
                  _buildConfirmField(),
                  const SizedBox(height: 8),
                  _buildTermsCheckbox(),
                  const SizedBox(height: 16),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----- Full name -----
  Widget _buildNameField() {
    return TextFormField(
      focusNode: _nameFocus,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Full name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: validateName,
      onSaved: (v) => _name = v!.trim(),
      // Name -> Email
      onFieldSubmitted: (_) => _emailFocus.requestFocus(),
    );
  }

  // ----- Email -----
  Widget _buildEmailField() {
    return TextFormField(
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: validateEmail,
      onSaved: (v) => _email = v!.trim(),
      // Email -> Password
      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
    );
  }

  // ----- Password -----
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Password',
        helperText: 'At least 8 characters and 1 digit',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        // Bonus: nút ẩn/hiện mật khẩu
        suffixIcon: IconButton(
          icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: validatePassword,
      // Khi password đổi, validate lại ô confirm (nếu người dùng đã nhập)
      onChanged: (_) {
        if (_confirmController.text.isNotEmpty) {
          _confirmKey.currentState?.validate();
        }
      },
      // Password -> Confirm
      onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
    );
  }

  // ----- Strength indicator (bonus) -----
  Widget _buildStrengthIndicator() {
    final level = passwordStrength(_passwordController.text);
    if (level == 0) return const SizedBox.shrink();

    const labels = ['', 'Weak', 'Medium', 'Strong'];
    const colors = [Colors.transparent, Colors.red, Colors.orange, Colors.green];

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: level / 3,
            color: colors[level],
            backgroundColor: Colors.grey.shade300,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Text(labels[level],
            style: TextStyle(color: colors[level], fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ----- Confirm password -----
  Widget _buildConfirmField() {
    return TextFormField(
      key: _confirmKey,
      controller: _confirmController,
      focusNode: _confirmFocus,
      obscureText: _obscureConfirm,
      // Ô cuối dùng "done"
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Confirm password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
      ),
      // So sánh với giá trị password hiện tại
      validator: (v) => validateConfirm(v, _passwordController.text),
      // Confirm -> gọi submit
      onFieldSubmitted: (_) => _submit(),
    );
  }

  // ----- Terms & Conditions (bonus) -----
  // Checkbox không phải TextFormField nên bọc trong FormField để
  // dùng được validator và hiển thị lỗi cùng cơ chế với Form.
  Widget _buildTermsCheckbox() {
    return FormField<bool>(
      initialValue: _acceptedTerms,
      validator: (value) =>
      value == true ? null : 'You must accept the terms to continue',
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('I accept the Terms & Conditions'),
              value: state.value ?? false,
              onChanged: (v) {
                _acceptedTerms = v ?? false;
                state.didChange(v);
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ----- Submit button -----
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        // Vô hiệu hóa nút khi đang kiểm tra email (onPressed = null)
        onPressed: _isCheckingEmail ? null : _submit,
        child: _isCheckingEmail
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        )
            : const Text('Sign Up'),
      ),
    );
  }
}