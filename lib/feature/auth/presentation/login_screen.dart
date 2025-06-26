import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/core/widget/custom_button.dart';
import 'package:study_hub/core/widget/custom_text_input.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _islogin = true;
  bool _isUploading = false;
  bool _showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAwesomeSnackbar(String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void _submit() async {
    bool valid = _formKey.currentState!.validate();
    if (!valid) return;
    setState(() {
      _isUploading = true;
    });
    try {
      if (_islogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _showAwesomeSnackbar(
            'Success', 'Logged in successfully!', ContentType.success);
      } else {
        await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _showAwesomeSnackbar(
            'Success', 'Account created successfully!', ContentType.success);
      }
    } on FirebaseAuthException catch (e) {
      _showAwesomeSnackbar(
          'Error', e.message ?? 'Authentication failed.', ContentType.failure);
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18),
                      Text(
                        'Welcome to Study Hub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: isDarkMode ? MyColors.white : MyColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Connect this device to your account.',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!_islogin) ...[
                        CustomTextInput(
                          hintText: 'Enter your username',
                          labelText: 'Username',
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 18),
                      ],
                      CustomTextInput(
                        hintText: 'Email',
                        labelText: 'Email',
                        controller: _emailController,
                        iconData: Icons.email,
                      ),
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDarkMode ? Colors.grey[300] : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            style: TextStyle(
                              color:
                                  isDarkMode ? MyColors.white : MyColors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color:
                                    isDarkMode ? Colors.grey[400] : Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                      isDarkMode ? MyColors.white : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? Colors.grey[700]!
                                      : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? Colors.grey[700]!
                                      : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDarkMode
                                      ? MyColors.primary
                                      : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              fillColor: isDarkMode
                                  ? MyColors.MyDarkTheme
                                  : Colors.white,
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      CustomButton(
                        label: _islogin ? 'SIGN IN' : 'SIGN UP',
                        onPressed: _isUploading ? () {} : _submit,
                        isLoading: _isUploading,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _islogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },
                            child: Text(
                              _islogin ? 'SIGN UP' : 'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.buttonPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'By submitting this form, you agree with\nTerms and Condition and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isUploading)
            Container(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.2),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: isDarkMode ? MyColors.white : MyColors.primary,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
