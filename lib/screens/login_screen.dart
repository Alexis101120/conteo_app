import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/ui/inputs_decorations.dart';
import 'package:flutter/material.dart';
import 'package:conteo_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Login', style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _LoginForm())
                ],
              )),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese usuario',
                  labelText: 'Usuario',
                  prefixIcon: Icons.account_circle),
              onChanged: (value) => loginForm.username = value,
              validator: (value) {
                return (value != null && !value.isEmpty)
                    ? null
                    : 'El usuario es requerido';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading ? 'Espere' : 'Ingresar',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;
                        final String? resp = await authService.login(
                            loginForm.username, loginForm.password);
                        if (resp == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          NotificationsService.showSnackbar(resp);
                          // showTopSnackBar(
                          //   context,
                          //   CustomSnackBar.error(
                          //     message: resp,
                          //   ),
                          // );
                          loginForm.isLoading = false;
                        }
                      })
          ],
        ),
      ),
    );
  }
}
