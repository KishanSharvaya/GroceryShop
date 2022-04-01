import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/models/common/globals.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/common_widgets.dart';


final primary = Colors.green;
final secondary = Colors.black;
final background = Colors.white10;
const colorPrimaryLight = const Color(0xff5fb47e);


const colorGrayDark = const Color(0xff6C777C);
const colorGray = const Color(0xffC4C4C4);
const CAPTION_SMALLER_TEXT_FONT_SIZE = 12.0;


Future navigateTo(BuildContext context, String routeName,
    {Object arguments,
      bool clearAllStack: false,
      bool clearSingleStack: false,
      bool useRootNavigator: false,
      String clearUntilRoute}) async {
  if (clearAllStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments);
  } else if (clearSingleStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .popAndPushNamed(routeName, arguments: arguments);
  } else if (clearUntilRoute != null) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(clearUntilRoute),
        arguments: arguments);
  } else {
    return await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamed(routeName, arguments: arguments);
  }
}
Future showCommonDialogWithSingleOption(
    BuildContext context,
    String message, {
      String positiveButtonTitle = "OK",
      GestureTapCallback onTapOfPositiveButton,
      bool useRootNavigator = true,
      EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
    }) async {
  ThemeData baseTheme = Theme.of(context);

  await showDialog(
    context: context,
    builder: (context2) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorWhite,
          ),
          width: double.maxFinite,
          margin: margin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 100),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      maxLines: 15,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: baseTheme.textTheme.button,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: getCommonDivider(),
              ),
              GestureDetector(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      positiveButtonTitle,
                      textAlign: TextAlign.center,
                      style: baseTheme.textTheme.button
                          .copyWith(color: colorPrimaryLight),
                    ),
                  ),
                ),
                onTap: onTapOfPositiveButton ??
                        () {
                      Navigator.of(Globals.context).pop();
                      // Navigator.of(context, rootNavigator: true).pop();
                    },
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget getCommonTextFormField(BuildContext context, ThemeData baseTheme,
    {String title: "",
      String hint: "",
      TextInputAction textInputAction: TextInputAction.next,
      bool obscureText: false,
      EdgeInsetsGeometry contentPadding:
      const EdgeInsets.only(top: 0, bottom: 10),
      int maxLength: 1000,
      TextAlign textAlign: TextAlign.left,
      TextEditingController controller,
      TextInputType keyboardType,
      FormFieldValidator<String> validator,
      int maxLines: 1,
      Function(String) onSubmitted,
      Function(String) onTextChanged,
      TextStyle titleTextStyle,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextStyle inputTextStyle,
      List<TextInputFormatter> inputFormatter,
      bool readOnly: false,
      Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle1;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.subtitle2;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title.isNotEmpty
          ? Container(
          child: /*Text(
          title,
          style: titleTextStyle,
        ),*/
          Text(
            title,
            style: TextStyle(
              color: Color(0xff5fb47e),
              fontSize: 18,
            ),
          ))
          : Container(),
      TextFormField(
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
        style: inputTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        cursorColor: colorPrimaryLight,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: maxLength,
        controller: controller,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: inputTextStyle.copyWith(color: colorGray),
          isDense: true,
          suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
          contentPadding: EdgeInsets.only(bottom: 10, top: 15),
          suffixIcon: IconTheme(data: IconThemeData(
              color: Colors.green
          ), child: suffixIcon),
          counterText: "",
          errorStyle: baseTheme.textTheme.subtitle1.copyWith(
              color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorGrayDark, width: 0.4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorPrimaryLight, width: 1),
          ),

        ),


        validator: validator,
        onChanged: onTextChanged,
        onFieldSubmitted: onSubmitted,

      )
    ],
  );
}

MaterialPageRoute getMaterialPageRoute(Widget screen) {
  return MaterialPageRoute(
    builder: (context) {
      return screen;

    },
  );


}