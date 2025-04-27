import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/models/discussion_answer.dart';
import '/models/discussion.dart';
import '/controllers/api_controller.dart';
import '/models/discussion_category.dart';
import '/res/enums/api_method.dart';

class DiscussionController extends GetxController {
  String _apiMessage = "";

  PagingController<int, Discussion>? _pagingController;

  PagingController<int, Discussion>? get pagingController => _pagingController;

  set pagingController(PagingController<int, Discussion>? controller) =>
      _pagingController = controller;

  String get apiMessage => _apiMessage;

  Future<List<DiscussionCategory>?> getCategories() async {
    List<DiscussionCategory>? result;

    await ApiController.instance.request(
      url: "forum/categories/",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (var value in response.data) {
          result?.add(DiscussionCategory.fromJson(value));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<List<Discussion>?> getDiscussions({
    required int categoryId,
    required int pageKey,
  }) async {
    List<Discussion>? result;

    await ApiController.instance.request(
      url: "forum/discussions/?category_id=$categoryId&pageKey=$pageKey",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (var value in response.data["results"]) {
          result?.add(Discussion.fromJson(value));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<List<DiscussionAnswer>?> getDiscussionMessages({
    required int discussionId,
  }) async {
    List<DiscussionAnswer>? result;

    await ApiController.instance.request(
      url: "forum/answers?discussion_id=$discussionId",
      method: ApiMethod.get,
      onSuccess: (response) {
        result = [];
        for (var value in response.data["results"]) {
          result?.add(DiscussionAnswer.fromJson(value));
        }
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> createDiscussion({
    required int categoryId,
    required String title,
    required String text,
    File? image,
  }) async {
    bool result = false;

    dio.FormData formData = dio.FormData.fromMap({
      "title": title,
      "text": text,
      "category_id": categoryId,
    });

    if (image != null) {
      formData.files.add(
        MapEntry(
          "image",
          await dio.MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }

    await ApiController.instance.request(
      url: "forum/discussions/",
      method: ApiMethod.post,
      data: formData,
      onSuccess: (response) {
        print(response);
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> discussionReaction({
    required int reaction,
    required int discussionId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "forum/discussion-reactions/",
      method: ApiMethod.post,
      data: {
        "reaction": reaction,
        "discussion": discussionId,
      },
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> removeDiscussionAnswerReaction({
    required int reactionId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "forum/discussion-answer-reactions/$reactionId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> removeDiscussionReaction({
    required int reactionId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "forum/discussion-reactions/$reactionId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<bool> discussionAnswerReaction({
    required int reaction,
    required int discussionId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "forum/discussion-answer-reactions/",
      method: ApiMethod.post,
      data: {
        "reaction": reaction,
        "discussion_answer": discussionId,
      },
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return result;
  }

  Future<DiscussionAnswer?> sendAnswerMessage({
    required String message,
    required int discussion,
    int? repliedAnswer,
  }) async {
    DiscussionAnswer? answer;

    Map data = {
      "answer": message,
      "discussion": discussion,
    };

    if (repliedAnswer != null) {
      data["replied_answer"] = repliedAnswer;
    }

    await ApiController.instance.request(
      url: "forum/answers/",
      method: ApiMethod.post,
      data: data,
      onSuccess: (response) {
        answer = DiscussionAnswer.fromJson(response.data);
      },
      onCatchDioError: (error) {
        _apiMessage = error.response?.data["detail"];
      },
      onCatchError: (error) {
        _apiMessage = "مشکلی پیش امده است";
      },
    );

    return answer;
  }
}
