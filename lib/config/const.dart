import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// COLOR
const branchColor = Color(0xFFED1B24);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF1D1D1D);
const greyColor = Color(0xFF959595);

// IMAGE

const urlLogo = 'assets/images/UNIQLO.png';
const urlLogo2 = 'assets/images/UNIQLO2.png';
const urlLogo3 = 'assets/images/UNIQLO3.png';
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

// Show Dialog
void showErrorDialog(BuildContext context, String message, bool isError) {
  Future.delayed(const Duration(seconds: 0), () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: isError ? 30 : 3), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            side: BorderSide(
              color: isError ? branchColor : Colors.green,
              width: 6,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isError
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline_rounded,
                color: isError ? branchColor : Colors.green,
                size: 100,
              ),
              const SizedBox(width: 10),
              Text(
                isError ? "Lỗi" : "Thành công",
                style: head,
              ),
            ],
          ),
          content: Text(
            message,
            style: body,
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Text(
          //       "OK",
          //       style: subhead,
          //     ),
          //   ),
          // ],
        );
      },
    );
  });
}
