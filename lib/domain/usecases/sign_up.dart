import 'dart:convert';
import 'package:ajoufinder/data/dto/sign_up_request.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp {
  static const String _endpoint = '/user/signup';
   
}