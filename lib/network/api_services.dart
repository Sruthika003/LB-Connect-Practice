
import 'package:dio/dio.dart';
import 'package:lb_connect_sample_project/model/country_list.dart';
import 'package:lb_connect_sample_project/model/email_verify_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

// @RestApi(baseUrl: "https://staging.lbconnect.com/")

@RestApi(baseUrl: "https://app.kaspontech.com/djadmin-qa/")
abstract class ApiService{
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // @POST("api/user-signup")
  // Future<EmailVerifyModel> signUp(@Body() Map<String, dynamic> body);

@GET("get_country/")
  Future<CountryResponse>getCountry();
}