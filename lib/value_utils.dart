import 'package:map_app_flutter/const.dart';

bool isValidTempF(double result) =>
    result >= QuestionnaireConstants.minF && result <= QuestionnaireConstants.maxF;

bool isValidTempC(double result) =>
    result >= QuestionnaireConstants.minC && result <= QuestionnaireConstants.maxC;

double cToF(double result) => (result * 9/5) + 32;
