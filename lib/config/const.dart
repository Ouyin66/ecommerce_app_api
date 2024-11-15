import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

// STRIPE API
const String stripePublishableKey =
    "pk_test_51QLP4qD6t5ZfQvhu1ZDjYQTG3kMYRwVTpKX4akK54LkcCqAYD9zVeGFrTfXnhBBL2MuDYOg6dpysv9DkEDdIyojM00anGKPXCR";
const String stripeSecretKey =
    "sk_test_51QLP4qD6t5ZfQvhuAerVpSXFLZwMIDJVfXdyV67Wtqk0kfVwj440kLCr14G8fXlIfpCz66Uf8v8LK6onaX1OkOId009acsmAFn";

// COLOR
const branchColor = Color(0xFFED1B24);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF1D1D1D);
const greyColor = Color(0xFF959595);

// IMAGE
const urlLogo = 'assets/images/UNIQLO.png';
const urlLogo2 = 'assets/images/UNIQLO2.png';
const urlLogo3 = 'assets/images/UNIQLO3.png';
const urlSuccess = 'assets/images/Success.png';
const urlGoogleLogo = 'assets/images/Google_Logo.png';
const urlFacebookLogo = 'assets/images/Facebook_Logo.png';
const urlForgetPassword = 'assets/images/Forget_Password.png';

// FONT
TextStyle head = GoogleFonts.barlow(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

TextStyle subhead = GoogleFonts.barlow(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

TextStyle body = GoogleFonts.barlow(
  fontSize: 18,
  color: blackColor,
  fontWeight: FontWeight.normal,
);

TextStyle label20 = GoogleFonts.barlow(
  fontSize: 20,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle label = GoogleFonts.barlow(
  fontSize: 24,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle infoLabel = GoogleFonts.barlow(
  fontSize: 18,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle info = GoogleFonts.barlow(
  fontSize: 18,
  color: greyColor,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
);

TextStyle labelGrey = GoogleFonts.barlow(
  fontSize: 24,
  color: greyColor,
  fontWeight: FontWeight.bold,
);

TextStyle error = GoogleFonts.barlow(
  fontSize: 14,
  color: branchColor,
  fontWeight: FontWeight.normal,
);

TextStyle productName = GoogleFonts.barlow(
  fontSize: 26,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle categoryText = GoogleFonts.barlow(
  fontSize: 16,
  color: greyColor,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
);

TextStyle textPrice = GoogleFonts.barlow(
  fontSize: 32,
  color: blackColor,
  fontWeight: FontWeight.bold,
);

TextStyle describe = GoogleFonts.barlow(
  fontSize: 16,
  color: blackColor,
  fontWeight: FontWeight.normal,
);

// TextFormField
dynamic EnableBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: greyColor, width: 1),
  );
}

dynamic FocusBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: blackColor, width: 2),
  );
}

dynamic ErrorBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: branchColor, width: 1),
  );
}

dynamic ErrorFocusBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
    borderSide: BorderSide(color: branchColor, width: 2),
  );
}

// Loading Screen
Widget LoadingScreen() {
  return const Center(
    child: CircularProgressIndicator(
      color: branchColor,
      backgroundColor: whiteColor,
    ),
  );
}

// Show Dialog
void showToast(BuildContext context, String message, {bool isError = false}) {
  FToast fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: isError ? branchColor : Colors.green,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isError ? Icons.cancel : Icons.check,
          color: whiteColor,
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.barlow(
              fontSize: 13,
              color: whiteColor,
              fontWeight: FontWeight.normal,
              // fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    toastDuration: const Duration(seconds: 3),
    gravity: ToastGravity.BOTTOM,
  );
}
