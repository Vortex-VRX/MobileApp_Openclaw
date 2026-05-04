import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_state.dart';
import '../../core/supabase_config.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          children: [
            const Icon(Icons.shopping_basket_outlined, color: Color(0xFF0AAD0A), size: 52),
            const SizedBox(height: 18),
            Text(
              _isSignUp ? 'Create your grocery account' : 'Log in to compare groceries',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Shop like Instacart, then compare the same cart across stores before you buy.',
              style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600, height: 1.35),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(_message!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _isLoading ? null : () => _submit(appState),
              child: _isLoading ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_isSignUp ? 'Sign up' : 'Log in'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                        _message = null;
                      });
                    },
              child: Text(_isSignUp ? 'I already have an account' : 'Create new account'),
            ),
            TextButton(
              onPressed: _isLoading ? null : () => appState.signIn('guest@openclaw.local'),
              child: const Text('Continue as guest'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(AppState appState) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.length < 6) {
      setState(() => _message = 'Enter an email and a password with at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      if (SupabaseConfig.isConfigured) {
        if (_isSignUp) {
          await Supabase.instance.client.auth.signUp(email: email, password: password);
        } else {
          await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
        }
      }
      appState.signIn(email);
    } on AuthException catch (error) {
      setState(() => _message = error.message);
    } catch (_) {
      setState(() => _message = 'Login is unavailable right now. You can continue as guest.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
