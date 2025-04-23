import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appwrite/appwrite.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/repository/auth_repo.dart';
// import 'package:news_now/src/screens/authentication/data/register.dart';
import 'package:news_now/src/screens/authentication/presentation/email_password_signin_validator.dart';
import 'package:news_now/src/screens/authentication/presentation/string_validator.dart';
import 'package:news_now/src/common_widgets/alert_dialogs.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';

class SignUpScreen extends StatefulWidget with EmailAndPasswordValidators {
  SignUpScreen({super.key});
  static const routeName = '/signup-screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  var _submitted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _node.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!FocusScope.of(context).hasPrimaryFocus) {
      FocusScope.of(context).unfocus();
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showExceptionAlertDialog(
        context: context,
        title: 'Password Error',
        exception: Text('Passwords do not match'),
      );
      setState(() => _submitted = false);
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await locator.get<AuthRepo>().signUp(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
              context,
            );
        if (mounted) {
          showAlertDialog(
            context: context,
            title: 'Account Created',
            content: Text('Your account has been created successfully.'),
            defaultActionText: 'OK',
          ).then((_) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          });
        }
      } on AppwriteException catch (e) {
        if (mounted) {
          showExceptionAlertDialog(
            context: context,
            title: e.code.toString(),
            exception: Text(e.message!),
          );
        }
      }
    }
    setState(() => _submitted = false);
  }

  void _nameEditingComplete() {
    _node.nextFocus();
  }

  void _emailEditingComplete() {
    if (widget.canSubmitEmail(_emailController.text)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!widget.canSubmitEmail(_emailController.text)) {
      _node.previousFocus();
      return;
    }
    _node.nextFocus();
  }

  void _confirmPasswordEditingComplete() {
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: FocusScope(
                          node: _node,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    hintText: 'John Doe',
                                    prefixIcon: Icon(Icons.person_outline,
                                        color: Color(0xFF6A11CB)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  onEditingComplete: _nameEditingComplete,
                                  validator: (name) => !_submitted
                                      ? null
                                      : (name == null || name.isEmpty)
                                          ? 'Name can\'t be empty'
                                          : null,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'example@xyz.com',
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: Color(0xFF6A11CB)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  onEditingComplete: _emailEditingComplete,
                                  validator: (email) => !_submitted
                                      ? null
                                      : widget.emailErrorText(email ?? ''),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  inputFormatters: <TextInputFormatter>[
                                    ValidatorInputFormatter(
                                      editingValidator:
                                          EmailEditingRegexValidator(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: '••••••••',
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Color(0xFF6A11CB)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xFF6A11CB),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  obscureText: _obscurePassword,
                                  onEditingComplete: _passwordEditingComplete,
                                  validator: (password) => !_submitted
                                      ? null
                                      : widget
                                          .passwordErrorText(password ?? ''),
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    hintText: '••••••••',
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Color(0xFF6A11CB)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Color(0xFF6A11CB),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  obscureText: _obscureConfirmPassword,
                                  onEditingComplete:
                                      _confirmPasswordEditingComplete,
                                  validator: (confirmPassword) => !_submitted
                                      ? null
                                      : (confirmPassword !=
                                              _passwordController.text)
                                          ? 'Passwords do not match'
                                          : null,
                                  textInputAction: TextInputAction.done,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: _submitted ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF6A11CB),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: _submitted
                                        ? SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Color(0xFF6A11CB),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
