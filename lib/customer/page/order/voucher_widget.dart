import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../config/const.dart';

class VoucherWidget extends StatefulWidget {
  const VoucherWidget({super.key});

  @override
  State<VoucherWidget> createState() => _VoucherWidgetState();
}

class _VoucherWidgetState extends State<VoucherWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vouchercontroller = TextEditingController();

  void getList() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor.withOpacity(0.97),
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Áp dụng voucher", style: head),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                urlLogo3,
                fit: BoxFit.cover,
                height: 50,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildVoucher(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoucher() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 4,
            child: _buildInputVoucher(),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: buildButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputVoucher() {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Form(
        key: _formKey,
        child: TextField(
          controller: _vouchercontroller,
          onChanged: (text) {
            setState(() {
              // _query = text;
              // searching(_query);
            });
          },
          decoration: InputDecoration(
            labelText: "Nhập voucher",
            labelStyle: const TextStyle(color: blackColor),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              borderSide: BorderSide(color: blackColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              borderSide: BorderSide(color: blackColor, width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              borderSide: BorderSide(color: blackColor, width: 2),
            ),
            prefixIcon: const Icon(Icons.percent_rounded),
            suffixIcon: _vouchercontroller.value.text != '' ||
                    _vouchercontroller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _vouchercontroller.clear();
                      });
                    },
                    icon: const Icon(Icons.cancel))
                : null,
          ),
          cursorColor: blackColor,
        ),
      ),
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: branchColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // shadowColor: Colors.black.withOpacity(0.5),
        // elevation: 8,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {}
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Text(
          "Áp dụng",
          style: subhead,
        ),
      ),
    );
  }
}
