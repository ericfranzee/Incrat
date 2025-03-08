import 'package:dio/dio.dart';
import 'package:it_academy/model/quiz/quiz_submit_model.dart';

abstract class Quiz {
  Future<Response> startQuize({required int quizId});
  Future<Response> submitQuiz(
      {required QuizSubmitModel quizSubmitModel, required int quizSessionId});
}
