import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// class UpdateData extends StatefulWidget {
//   String? id;
//   String? firstName;
//   String? lastName;
//   String? message;
//   UpdateData({
//     super.key,
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.message,
//   });

//   @override
//   State<UpdateData> createState() => _UpdateDataState();
// }

// class _UpdateDataState extends State<UpdateData> {
//   //var myres;
//   var idController = TextEditingController();
//   var firstName = TextEditingController();
//   var lastName = TextEditingController();
//   var message = TextEditingController();

//   var _updateFormKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     idController.text = widget.id!;
//     firstName.text = widget.firstName!;
//     lastName.text = widget.lastName!;
//     message.text = widget.message!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var myUpdateProvider = Provider.of<GetProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Data'),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _updateFormKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: idController,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter value';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: firstName,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter value';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: lastName,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter value';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               TextFormField(
//                 controller: message,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter value';
//                   } else {
//                     return null;
//                   }
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_updateFormKey.currentState!.validate()) {
//                     var myres = myUpdateProvider.updateData(
//                       // idController.text.toString(),
//                       idController.text.toString(),
//                       firstName.text.toString(),
//                       lastName.text.toString(),
//                       message.text.toString(),
//                     );
//                     Navigator.pop(context, myres);
//                     //Provider.of<GetProvider>(context, listen: false).getData();

//                     // Navigator.pop(context);
//                     //print('Data Updated');
//                   }
//                 },
//                 child: Text(
//                   'Update Data',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
