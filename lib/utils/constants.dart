import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../theme/theme_provider.dart';

var primaryColor = Vx.hexToColor('#1B62DB');
//LOADER
var loader = SizedBox(
  height: 2.0,
  width: 100.0,
  child: LinearProgressIndicator(
      // value: animation.value,
      color: Colors.white,
      backgroundColor: primaryColor),
).p12();

// INPUT DECORATION
var textInputDecoration = InputDecoration(
  errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
  ),
  filled: true,
  focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0)),
);

// BACKGROUND IMAGE
const backgroundImage = BoxDecoration(
  image: DecorationImage(
    // colorFilter:
    //     ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
    image: AssetImage(
      'assets/images/background-01.png',
    ),
    fit: BoxFit.cover,
  ),
);

//LOGO
final logo = Card(
  semanticContainer: true,
  clipBehavior: Clip.antiAliasWithSaveLayer,
  shape: RoundedRectangleBorder(
    side: const BorderSide(color: Colors.white, width: 0),
    borderRadius: BorderRadius.circular(25.0),
  ),
  margin: const EdgeInsets.all(0.0),
  elevation: 0.0,
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    ),
  ),
);

SnackBar snackbar(context, message, duration) {
  SnackBar snackBar = SnackBar(
    backgroundColor: Theme.of(context).colorScheme.onBackground,
    dismissDirection: DismissDirection.down,
    duration: Duration(seconds: duration),
    behavior: SnackBarBehavior.floating,
    content:
        "$message".text.color(Theme.of(context).colorScheme.background).make(),
  );
  return snackBar;
}

TextFormField input(context, value, label, func, validatorFun, regEx) {
  setVal(val) {
    return val;
  }

  return TextFormField(
    decoration: textInputDecoration.copyWith(
      hintText: '$label',
      labelText: 'Enter $label',
      fillColor: Theme.of(context).colorScheme.background,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    ),
    onChanged: (val) {
      // setState(() {
      //   email = val;
      // });
      setVal(val);
    },
    validator: (val) {
      if (val!.isEmpty) {
        return 'This field is required';
      } else if (!RegExp("$regEx").hasMatch(val)) {
        return 'Enter a valid email';
      }
      return null;
      // validatorFun;
      // return null;
    },
  );
}

ElevatedButton btn(context, fun, value, size) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () async {
        await fun();
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 115,
        ),
        child: '$value'.text.size(size).make(),
      ));
}

ElevatedButton drawerBtn(
  context,
  func,
  pageName,
  value,
  iconName,
) {
  var MyColor = Theme.of(context).extension<MyColors>()!;

  var buttonStyle = ElevatedButton.styleFrom(
    elevation: 10,
    primary: Theme.of(context).backgroundColor,
    onPrimary: Colors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  return ElevatedButton(
    style: buttonStyle,
    onPressed: () async {
      Future.delayed(const Duration(milliseconds: 200), () async {
        if (func == "") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => pageName));
        } else {
          func;
        }
      });
    },
    child: ListTile(
      leading: Icon(
        iconName,
        color: MyColor.textColor,
      ),
      title: '$value'.text.bold.letterSpacing(1).make(),
    ),
  );
}
