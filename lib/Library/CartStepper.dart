
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'AppColors.dart';

class CartStepper extends StatefulWidget {
  CartStepper({super.key,
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.stepValue,
    @required this.iconSize,
    @required this.value,
    @required this.isTextFormField,
    @required this.textFormFieldWidth,
    this.onChange,
  });

  int? lowerLimit;
  int? upperLimit;
  int? stepValue;
  final double? iconSize;
  int? value;
  double? textFormFieldWidth;
  final ValueChanged<String>? onChange;
  final bool? isTextFormField;


  @override
  _CartStepperState createState() => _CartStepperState();
}

class _CartStepperState extends State<CartStepper> {

  TextEditingController qtnController = TextEditingController();

  @override
  void initState() {
    setState(() {
      qtnController.text = widget.value.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedIconButton(
          icon: Icons.remove,
          bgcolor: widget.value==widget.lowerLimit?AppColors.grey_09:AppColors.primaryColor,
          iconSize: double.parse(widget.iconSize.toString()),
          onPress: () {
            if(widget.value != widget.lowerLimit){
              setState(() {
                widget.value = widget.value == widget.lowerLimit ? widget.lowerLimit : widget.value! - widget.stepValue!;
              });
              widget.onChange == null?"":widget.onChange!(widget.value.toString());
              qtnController.text = widget.value.toString();
            }

          },
        ),
        Visibility(
          visible: !(widget.isTextFormField??true),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${widget.value}',
              style: TextStyle(
                fontSize: widget.iconSize! * 0.7,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        Visibility(
          visible: (widget.isTextFormField??true),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:5.0),
            child: SizedBox(
              width: widget.textFormFieldWidth??40,
              child: TextFormField(
                controller: qtnController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTextStyle.displayLarge,
                showCursor: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (val){
                  if(((val??"").isEmpty) || (double.parse(val.toString()).round() < double.parse(widget.lowerLimit.toString()).round()) || (double.parse(val.toString()).round() > double.parse(widget.upperLimit.toString()).round())){
                    return "";
                  }else{
                    return null;
                  }
                },
                onChanged: (val){
                  if((double.parse(val.toString()).round() >= double.parse(widget.lowerLimit.toString()).round()) && (double.parse(val.toString()).round() <= double.parse(widget.upperLimit.toString()).round())){
                    setState(() {
                      widget.value = double.parse(val.toString()).round();
                    });
                    widget.onChange == null?"":widget.onChange!(widget.value.toString());
                  }
                },
                onTap: (){
                  qtnController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: qtnController.text.length,
                  );
                },
                decoration: InputDecoration(
                  errorStyle: AppTextStyle.textError,
                  hintText: "0",
                  hintStyle: AppTextStyle.textHint,
                  counterText: "",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.inputColor,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inputColor, width: 1.8),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.inputColor,
                      width: 1.8,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ),

        RoundedIconButton(
          icon: Icons.add,
          iconSize: double.parse(widget.iconSize.toString()),
          bgcolor: widget.value==widget.upperLimit?AppColors.primaryColorLight:AppColors.primaryColor,
          onPress: () {
            if(widget.value != widget.upperLimit){
              setState(() {
                widget.value = widget.value == widget.upperLimit ? widget.upperLimit : widget.value! + widget.stepValue!;
              });
              widget.onChange == null?"":widget.onChange!(widget.value.toString());
              qtnController.text = widget.value.toString();
            }

          },
        ),
      ],
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({super.key, @required this.icon, @required this.onPress, @required this.iconSize, @required this.bgcolor});

  final IconData? icon;
  final dynamic onPress;
  final double? iconSize;
  final Color? bgcolor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: iconSize,
        width: iconSize,
        decoration: BoxDecoration(
          color: bgcolor??AppColors.primaryColor,
          borderRadius: BorderRadius.circular(iconSize! * 0.2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey_09,
              offset: Offset(0,0.5),
              spreadRadius: 1,
              blurRadius: 3
            ),
          ]
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: iconSize! * 0.8,
          ),
        ),
      ),
    );
  }
}