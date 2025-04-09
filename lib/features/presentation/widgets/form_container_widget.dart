import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/cubit/obscure_text/obscure_text_cubit.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;

  const FormContainerWidget(
      {super.key,
      this.controller,
      this.fieldKey,
      this.isPasswordField,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldSubmitted,
      this.inputType});

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(3)),
      child: BlocBuilder<ObscureTextCubit, bool>(
        builder: (context, obscureText) {
          return TextFormField(
            style: const TextStyle(color: primaryColor),
            controller: widget.controller,
            keyboardType: widget.inputType,
            key: widget.fieldKey,
            obscureText: widget.isPasswordField == true ? obscureText : false,
            onSaved: widget.onSaved,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: secondaryColor,
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      context.read<ObscureTextCubit>().toggel();
                    },
                    child: widget.isPasswordField == true
                        ? Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: obscureText == false
                                ? blueColor
                                : secondaryColor,
                          )
                        : const Text(""))),
          );
        },
      ),
    );
  }
}
