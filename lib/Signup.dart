
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  final usernamecontroller = TextEditingController();

  final emailcontroller = TextEditingController();

  final phonecontroller = TextEditingController();

  final passwordcontroller = TextEditingController();
  final repasswordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Text(
                    'Create New Account',
                    style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: usernamecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(color: Colors.white),
                decoration: _buildid("Username", Icons.person),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
                controller: phonecontroller,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildid("Phone Number", Icons.call),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: passwordcontroller,
              style: const TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildid("Password", Icons.lock),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: repasswordcontroller,
              style: const TextStyle(color: Colors.white),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: _buildid("Re Enter Password", Icons.lock),
              validator: (value) {
                if (value != passwordcontroller.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
            ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF949494),
                      ),
                      const SizedBox(width: 8), // Add some spacing between icon and text
                      Text(
                        _isPasswordVisible ? 'Hide Password' : 'Show Password',
                        style: const TextStyle(color: Color(0xFF949494)),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      // isloader ? "" : _submitf();
                    },
                    style: ElevatedButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: /*isloader ? const Center(child: CircularProgressIndicator()):*/
                    const Text('Create Account',style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account',style: TextStyle(color: Colors.white),),
                    TextButton(
                        onPressed: (){
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));

                        },
                        child: const Text('Login',style: TextStyle(color: Color.fromARGB(255, 241, 89, 0),decoration: TextDecoration.underline,decorationColor: Color.fromARGB(255, 241, 89, 0)),)
                    ),
                  ],
                )
              ],
            ),

          ),
        ),
      ),
    );
  }
  InputDecoration _buildid(String label, IconData suinc){
    return InputDecoration(
        fillColor: const Color(0xAA494A59),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        filled: true,
        labelStyle: const TextStyle(color: Color(0xFF949494)),
        labelText: label,
        suffixIcon: Icon(suinc,color: const Color(0xFF949494),),
        border: OutlineInputBorder(borderRadius:BorderRadius.circular(10))
    );
  }
}
