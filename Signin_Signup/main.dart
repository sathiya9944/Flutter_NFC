import 'package:flutter/material.dart';

// Main function to start the Flutter app
void main() {
  runApp(const MyApp());
}

// Student model to store user data
class Student {
  final String name;
  final String email;
  final String password;

  Student({required this.name, required this.email, required this.password});
}

// Global list to store registered students (in-memory)
List<Student> students = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Student App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Blue theme for the app
      ),
      initialRoute: '/signin', // Start at Sign In page
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}

// ---------------- Sign In Page ----------------
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers for text input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle sign-in logic
  void _signIn() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Check if credentials match any registered student
      for (var student in students) {
        if (student.email == email && student.password == password) {
          Navigator.pushNamed(
            context,
            '/welcome',
            arguments: student.name, // Pass the student's name
          );
          return;
        }
      }
      // Show error if credentials don't match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email TextField with validation
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(), // Material Design border
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Password TextField with validation
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Hide password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Sign In button
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In'),
              ),
              // Link to Sign Up page
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Sign Up Page ----------------
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for text input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle sign-up logic
  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Add new student to the list
      students.add(
        Student(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );
      // Navigate to Sign In page
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name TextField with validation
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Email TextField with validation
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Password TextField with validation
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Confirm Password TextField with validation
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Sign Up button
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Sign Up'),
              ),
              // Link to Sign In page
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Welcome Page ----------------
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the username from navigation arguments
    final String username =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Text(
          'Hello $username!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}