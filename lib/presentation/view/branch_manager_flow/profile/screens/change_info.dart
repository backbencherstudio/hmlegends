import 'package:flutter/material.dart';

class ChangeInfo extends StatelessWidget {
  const ChangeInfo({super.key});
  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          Column(spacing: 10,
            children: [
              SizedBox(height: 20,),
              Text(
                'Discard Changes?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ), Text(
                'Unsaved changes will be lost',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Color(0xff4A4C56)),
              ),
              SizedBox(height: 10,),
              Column(spacing: 6,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showSubmitDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffE20613),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:  EdgeInsets.symmetric(horizontal: 120, vertical: 8),
                    ),
                    child: const Text('Yes',   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xffE20613),
                      side:  BorderSide(color: Color(0xffE20613)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 8),
                    ),
                    child: const Text(
                      'No, Keep',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),


                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF6F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Personal Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            children: [
              SizedBox(height: 15,),
               Text(
                'Cancel',
                style: TextStyle(color: Color(0xffE20613), fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {_showSubmitDialog(context);},
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xffE20613), fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(),
            const SizedBox(height: 16.0),
            const LabeledInputField(
              label: 'First Name',
              placeholder: 'Cameron',
            ),
            const LabeledInputField(
              label: 'Last Name',
              placeholder: 'Williamson',
            ),
            const LabeledInputField(
              label: 'Occupation',
              placeholder: "Head of Legends's branch-02",
            ),
            const LabeledInputField(
              label: 'Date of birth',
              placeholder: '10/06/1990',
            ),
            const LabeledInputField(
              label: 'Phone Number',
              placeholder: '+123-254-2530',
              isNumeric: true,
            ),
            const LabeledInputField(
              label: 'City',
              placeholder: 'Boston, MA',
            ),
            const LabeledInputField(
              label: 'Address',
              placeholder: '123 Main St, Apt 4B',
              isMultiline: true,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFE20613), // Primary red
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // User Avatar (Placeholder)
                ClipOval(
                  child: Image.asset(
                    'assets/images/panda.jpeg', scale:2.7,// Placeholder image
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                // Camera/Edit Icon
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFFD32F2F),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Name
            const Text(
              'Cameron Williamson',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Role/Title
            const Text(
              "Head of Legends's branch-02",
              style: TextStyle(
                  color: Color(0xFFF0F0F0), // Lighter white/grey
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isNumeric;
  final bool isMultiline;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isNumeric = false,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xff4A4C56),
              ),
            ),
          ),
          // Text Field
          TextField(
            maxLines: isMultiline ? 3 : 1,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Color(0xff777980)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              filled: true,
              fillColor: Color(0xffF6F6F7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Color(0xffE20613), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(color: Colors.grey.shade400,width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

