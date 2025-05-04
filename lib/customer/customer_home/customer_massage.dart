import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_cleaners_app/firebase/firebase_service.dart';
import 'package:lottie/lottie.dart';

class CustomerMassage extends StatefulWidget {
  const CustomerMassage({super.key});

  @override
  State<CustomerMassage> createState() => _CustomerMassageState();
}

class _CustomerMassageState extends State<CustomerMassage> {
   final double _rating = 0;

   final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    _emailController.dispose(); // Dispose email controller
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ You need to be logged in to submit a review')),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      await FirebaseService().addCustomerFeedback(
        _emailController.text,
        _reviewController.text,
        DateTime.now(),
        user!.email!, // Ensure user is logged in
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Review sent successfully!')),
      );

      // Clear the form
      _reviewController.clear();
      _emailController.clear();
    } catch (e) {
      print("❌ Error submitting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to send review! Try again.')),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  //   final TextEditingController _reviewController = TextEditingController();
  //   final TextEditingController _emailController = TextEditingController();
  //   final _formkey = GlobalKey<FormState>();

 
  // bool _isSubmitting = false;
  // bool _isLoaded = false;

  // @override
  // void dispose() {
  //   _reviewController.dispose();
  //   super.dispose();
  // }

  // void _submitReview() {
  //   if (_reviewController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please write a review before submitting')),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isSubmitting = true;
  //   });

  //   // Simulate sending the email
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       _isSubmitting = false;
        
        
  //     });
      
  //     // Show success message
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Review sent successfully!')),
        
  //     );
      
  //     // Clear the form
  //     _reviewController.clear();
  //   });
  // }

  // Future customerFeedback() async{
  //   if(!_formkey.currentState!.validate()){
  //     return;
  //   }
  //   setState(() {
  //     _isLoaded = true;

  //   });

  //   try{
  //     final email = _emailController.text;
  //     final review = _reviewController.text;
  //     DateTime date = DateTime.now();

  //     User? user = FirebaseAuth.instance.currentUser;

  //     await FirebaseService().addCustomerFeedback(email, review, date, user!.email! );
  //     print("✅ Customer feedback added successfully!");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('😏Review sent successfully!')),
  //     );
  //   }
  //   catch(e){
  //     print("❌ Failed to add customer feedback: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('😡Failed to send review!')),
  //     );
  //   }
 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Share Your Experience',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your feedback helps us improve our cleaning services.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Rating section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              // _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Email format for review
              const Text(
                'Email Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email header
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'To :'
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Subject: My Experience with Your Cleaning Service'),
                        ],
                      ),
                    ),
                    
                    // Email body - Review text field
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _reviewController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            hintText: 'Write your review here...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Send button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SEND REVIEW',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        ),
    );
  }
}
