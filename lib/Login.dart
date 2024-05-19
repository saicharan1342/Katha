import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  var isloader=false;
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const SizedBox(
                    width: 200,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildid("Phone Number", Icons.phone),
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
                  Row(
                    children: [
                      TextButton(onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const ForgotPasswordScreen(),
                        //   ),
                        // );
                      }, child: const Text('Forgot Password',style: TextStyle(color: Colors.red,decoration:TextDecoration.underline,decorationColor: Colors.red),)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Row(
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
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // Text(errore,style: TextStyle(color: Colors.red),),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ()  {
                        //isloader?"":_submitf();
                      },
                      style: ElevatedButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: /*isloader ? const Center(child: CircularProgressIndicator()):*/
                      const Text('Login',style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account",style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: (){
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Signupform()));

                          },
                          child: const Text('Create Account',style: TextStyle(color: Color.fromARGB(255, 241, 89, 0),decoration: TextDecoration.underline,decorationColor: Color.fromARGB(255, 241, 89, 0)),)
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
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
