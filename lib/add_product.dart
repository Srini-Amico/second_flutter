import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';

class addproductpage extends StatefulWidget {
  @override
  _addproductpageState createState() => _addproductpageState();
}

class _addproductpageState extends State<addproductpage> {
  TextEditingController dateInput = TextEditingController();

  File? _image; //date

  // final _picker = ImagePicker(); // File? pickedImage;
  bool isPicked = false;
  bool _isEnable = false; //iconbutton add/edit
  // bool _isChecked = false; //terms&conditions checkbox
  var currentSelectedValue;

  static const deviceTypes = [
    "Electronics",
    "Events",
    "Gamers",
    "Gardening",
    "Households",
    "Music",
    "Outdoors",
    "Parking",
    "Sports",
    "Tools",
    "Toys",
    "Transportation"
  ];

  bool agree = false; //publish to market
  bool valuefirst = false; //checkbox first
  bool valuesecond = false; //checkbox second

  String page = "add-product"; //variable declaration

  void initState() {
    dateInput.text = ""; //date
    super.initState();
  }

  // Widget add_image(){
  //   var visible = page == "add-image";
  //   return Visibility(
  //       child:(Text(
  //         "Add-image",
  //         // style: TextStyle( color: Color.fromRGBO(9, 30, 80, 0.7), fontSize: 15,fontWeight: FontWeight.bold),
  //       )),
  //       visible: visible
  //   );
  // }


  void _doSomething() {}//elevated button

  Widget add_image(){
    var visible = page == "add-image";
    return Visibility(
      child: Container(
        padding: EdgeInsets.all(15),
        // margin: EdgeInsets.all(5),
        height: 230,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            GestureDetector(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 3.0, 0),
                  child: Icon(Icons.folder,color: Colors.orange,size: 60,)),
              onTap: () async  {
                // final XFile? pickedImage =
                // await _picker.pickImage(source: ImageSource.gallery,);
                // if (pickedImage != null) {
                //   setState(() {
                //     _image = File(pickedImage.path);
                //   });
                // }

              },
            ),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Text(" Choose images here ..",
                    style: TextStyle(fontSize: 17,color: Colors.blueGrey,fontWeight: FontWeight.w400)
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Max file size :50mb",style: TextStyle(color: Colors.blueGrey,fontSize: 17,
                    fontWeight: FontWeight.w400),),
              ],
            ),
            SizedBox(height: 60,),
            Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              // margin: EdgeInsets.all(25),
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => productdetailspage()));
                },
                child: Text(
                  'Proceed',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              width: 250,
              height: 150,
              color: Colors.grey[300],
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.fill)
                  : const Text(''),
            ),
          ],
        ),
      ),

      visible: visible,
    );
  }

  Widget tell_something(){
    return Text(
      "Tell something about the product",
      style: TextStyle( color: Color.fromRGBO(9, 30, 80, 0.7), fontSize: 15,fontWeight: FontWeight.bold),
    );
  }

  Widget main_add_product(){
    var visible = page == "add-product";
    return Visibility(
        visible: visible,
        child:Center(
            child: Card(
              // elevation: 50,
              shadowColor: Colors.black,
              // color: Colors.greenAccent[100],
              child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        tell_something(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  page = "add-image";
                                  // var _isContainerVisible = !_isContainerVisible;
                                });
                              },
                              child: Text(
                                " Add Images",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Display name *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onTap: (){},
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            focusColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // indicatorColor: kPrimaryColor,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Product Name",
                          ),

                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          //Normal textInputField will be displayed
                          maxLines: 5,
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintText: " Some description about your product ",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity * ",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Dimension *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor:Color(0xFFE3F2FD),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  hintText: " Width",
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor:Color(0xFFE3F2FD),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  hintText: " Height",
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor:Color(0xFFE3F2FD),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  hintText: " Cm   ",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Manufacturing date *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: dateInput,
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),//box size increase/decrease
                            hintText: "dd-mm-yyy",
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                              DateFormat('dd-MM-yyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Price Per day(INR) *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            // fillColor: Color(0xFFECEFF1),
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Refundable deposits(INR) * i",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Product category *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // height: 100,
                          // width: double.infinity,
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          margin: EdgeInsets.all(1),
                          decoration: BoxDecoration(),
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  fillColor:Color(0xFFE3F2FD),
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text("Electronics"),
                                    value: currentSelectedValue,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        currentSelectedValue = newValue;
                                      });
                                      print(currentSelectedValue);
                                    },
                                    items: deviceTypes.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Product Location *",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    _isEnable = true;
                                  });
                                }),
                            Text("Edit"),
                            IconButton(
                                icon: Icon(Icons.add_outlined),
                                onPressed: () {
                                  setState(() {
                                    _isEnable = true;
                                  });
                                }),
                            Text("Add"),
                            // Text("Add"),
                          ],
                        ),
                        TextField(
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "Santhom Nagar,India",
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              // checkColor: Colors.greenAccent,
                              // activeColor: Colors.red,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ), //Checkbox
                            Text(
                              'Borrower Can Pickup Product from me',
                              style: TextStyle(fontSize: 14.5),
                            ),
                          ], //<Widget>[]
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: this.valuesecond,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuesecond = value!;
                                });
                              },
                            ),
                            Text(
                              'I can drop the Product to Borrower',
                              style: TextStyle(fontSize: 15.0),
                            ), //Text
                          ], //<Widget>[]
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Tags * ",
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            fillColor:Color(0xFFE3F2FD),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: "",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.white60)),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: RichText(
                              text: TextSpan(
                                text: 'I accept and acknowledge the',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Disclaimers .',
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15.0)),
                                  TextSpan(
                                      text:
                                      ' I will use the AnyStuff.rent platform per the ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0)),
                                  TextSpan(
                                      text: ' Terms & Conditions',
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                          fontSize: 15.0)),
                                ],
                              ),
                            ),
                            value: agree,
                            onChanged: (value) {
                              setState(() {
                                agree = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //              color: Color.fromRGBO(9, 30, 80, 0.7),
                        //           borderRadius: BorderRadius.circular(10)),
                        //   child: TextButton(
                        //       onPressed: agree ? _doSomething : null,
                        //       child: const Text('Publish to market',),
                        // ),
                        // ),
                        Container(
                          width: 350,
                          child: ElevatedButton(
                            onPressed: agree ? _doSomething : null,
                            child: const Text('  Puplish to market' ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ), //CircleAvatar
                  )),
            )));
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children:[
            main_add_product(),
            add_image(),
          ],
        )
    );
  }
}