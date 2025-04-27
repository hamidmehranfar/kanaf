import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:video_player/video_player.dart';

import '/res/enums/media_type.dart';
import '/controllers/api_controller.dart';
import '/models/like.dart';
import '/models/post.dart';
import '/models/post_comment.dart';
import '/res/enums/api_method.dart';

class PostController extends GetxController {
  List<Post> _posts = [];

  String _apiMessage = "";

  VideoPlayerController? _currentPlayedVideoController;

  RxInt _postCurrentIndex = 0.obs;

  List<(File?, MediaType?)> _createdPosts =
      List.generate(6, (index) => (null, null));

  List<bool> _createdPostsLoading = List.generate(6, (index) => false);

  final List<(Map<int, VideoPlayerController>, int, bool)> _videoControllers =
      [];

  TextEditingController? _captionTextController;

  List<Post> get posts => _posts;

  bool _createPostLoading = false;

  String get apiMessage => _apiMessage;

  TextEditingController? get captionTextController => _captionTextController;

  List<(File?, MediaType?)> get createdPosts => _createdPosts;

  RxInt get postCurrentIndex => _postCurrentIndex;

  void setPostCurrentIndex(int index) => _postCurrentIndex.value = index;

  VideoPlayerController? get currentPlayedVideoController =>
      _currentPlayedVideoController;

  set currentPlayedVideoController(VideoPlayerController? controller) =>
      _currentPlayedVideoController = controller;

  List<bool> get createdPostsLoading => _createdPostsLoading;

  List<(Map<int, VideoPlayerController>, int, bool)> get videoControllers =>
      _videoControllers;

  bool get createPostLoading => _createPostLoading;

  set createPostLoading(bool loading) => _createPostLoading = loading;

  void initCaptionTextController() {
    _captionTextController = TextEditingController();
  }

  void initPostValues() {
    _createdPosts = List.generate(6, (index) => (null, null));
    _createdPostsLoading = List.generate(6, (index) => false);

    _createPostLoading = false;
  }

  void initVideoControllers() {
    _videoControllers.clear();

    for (int i = 0; i < _posts.length; i++) {
      _videoControllers.add(({}, 0, true));
    }
  }

  Future<bool> getPosts({
    required int profileId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "master/posts/?profile_id=$profileId",
      method: ApiMethod.get,
      onSuccess: (response) {
        _posts = [];
        for (var item in response.data["results"]) {
          _posts.add(Post.fromJson(item));
        }
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data?['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<(Post?, bool)> getPostDetails(int postId) async {
    Post? post;
    bool isPostLike = false;

    await ApiController.instance.request(
      url: "master/posts/$postId",
      method: ApiMethod.get,
      onSuccess: (response) {
        isPostLike = response.data["current_user_like"] != null;
        post = Post.fromJson(response.data);
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return (post, isPostLike);
  }

  Future<bool> createPost({required String caption}) async {
    bool result = false;

    List<(File, MediaType)> selectedImages = [];
    for (var image in _createdPosts) {
      if (image.$1 != null && image.$2 != null) {
        selectedImages.add((image.$1!, image.$2!));
      }
    }

    dio.FormData formData = dio.FormData.fromMap({
      "caption": caption,
    });

    for (int i = 0; i < selectedImages.length; i++) {
      formData.fields.add(MapEntry("items[$i]item_type",
          selectedImages[i].$2 == MediaType.image ? '0' : '1'));
      formData.files.add(
        MapEntry(
          "items[$i]file",
          await dio.MultipartFile.fromFile(selectedImages[i].$1.path,
              filename: selectedImages[i].$1.path.split('/').last),
        ),
      );
    }

    await ApiController.instance.request(
      url: 'master/posts/',
      method: ApiMethod.post,
      data: formData,
      isMultipleFiles: true,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  // Future<bool> editPosts(Post post, String? caption) async {
  //   bool? result;
  //
  //   if (caption != null) {
  //     await _editPostCaption(post.id, caption).then(
  //       (value) {
  //         result = value;
  //       },
  //     );
  //   }

  // if (result != null && result! && checkIsItemsChange(post)) {
  //   await _editPostItems(post.id).then((value) {
  //     if (result == null) {
  //       result = value;
  //     } else {
  //       result = result! && value;
  //     }
  //   });
  // }

  //   return result ?? false;
  // }

  // Future<bool> _editPostItems(int postId) async {
  //   bool result = false;
  //
  //   List<File> selectedImages = [];
  //   for (var image in _networkImages) {}
  //
  //   dio.FormData formData = dio.FormData();
  //
  //   for (int i = 0; i < selectedImages.length; i++) {
  //     formData.fields.add(MapEntry("items[$i]item_type", "0"));
  //     formData.files.add(
  //       MapEntry(
  //         "items[$i]file",
  //         await dio.MultipartFile.fromFile(selectedImages[i].path,
  //             filename: selectedImages[i].path.split('/').last),
  //       ),
  //     );
  //   }
  //
  //   await ApiController.instance.request(
  //     url: "master/posts/items/$postId",
  //     method: ApiMethod.patch,
  //     onSuccess: (response) {
  //       result = true;
  //     },
  //     onCatchDioError: (e) {
  //       _apiMessage = e.response?.data['detail'] ?? '';
  //     },
  //     onCatchError: (e) {
  //       _apiMessage = 'مشکلی پیش آمده است';
  //     },
  //   );
  //
  //   return result;
  // }

  Future<bool> editPostCaption({
    required int postId,
    String? caption,
  }) async {
    Map payload = {
      "caption": caption,
    };

    bool result = false;

    await ApiController.instance.request(
      url: "master/posts/$postId/",
      method: ApiMethod.patch,
      data: caption != null ? payload : null,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> deletePost({
    required int postId,
  }) async {
    bool result = false;

    await ApiController.instance.request(
      url: "master/posts/$postId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<List<PostComment>?> getPostComments(int postId) async {
    List<PostComment>? postComments;
    await ApiController.instance.request(
      url: "master/comments/?profile_post_id=$postId",
      method: ApiMethod.get,
      onSuccess: (response) {
        postComments = [];
        for (var item in response.data["results"]) {
          postComments?.add(PostComment.fromJson(item));
        }
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return postComments;
  }

  Future<PostComment?> getCommentDetail(int commentId) async {
    PostComment? postComment;

    await ApiController.instance.request(
      url: "master/comments/$commentId",
      method: ApiMethod.get,
      onSuccess: (response) {
        postComment = PostComment.fromJson(response.data);
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return postComment;
  }

  Future<bool> createComments(int postId, String comment) async {
    bool result = false;

    await ApiController.instance.request(
      url: "master/comments/",
      method: ApiMethod.post,
      data: {
        "post": postId,
        "comment": comment,
      },
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> editPostComments(int commentId, String comment) async {
    bool result = false;
    await ApiController.instance.request(
        url: "master/comments/$commentId/",
        method: ApiMethod.patch,
        data: {
          "comment": comment,
        },
        onSuccess: (response) {
          result = true;
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return result;
  }

  Future<bool> deletePostComment(int commentId) async {
    bool result = false;
    await ApiController.instance.request(
        url: "master/comments/$commentId/",
        method: ApiMethod.delete,
        onSuccess: (response) {
          result = true;
          _apiMessage = response.data["detail"] ?? '';
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return result;
  }

  Future<List<Like>?> getPostLikes(int postId) async {
    List<Like>? postLikes;
    await ApiController.instance.request(
      url: "master/likes/?profile_post_id=$postId",
      method: ApiMethod.get,
      onSuccess: (response) {
        postLikes = [];
        for (var item in response.data["results"]) {
          postLikes?.add(Like.fromJson(item));
        }
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return postLikes;
  }

  Future<(bool, int?)> createPostLikes(int postId) async {
    bool result = false;
    int? likeId;

    await ApiController.instance.request(
      url: "master/likes/",
      data: {
        "post": postId,
      },
      method: ApiMethod.post,
      onSuccess: (response) {
        likeId = response.data["id"];
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return (result, likeId);
  }

  Future<bool> deletePostLikes(int postId) async {
    bool result = false;
    await ApiController.instance.request(
      url: "master/likes/$postId/",
      method: ApiMethod.delete,
      onSuccess: (response) {
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }

  Future<bool> getSearchPosts(String keyword) async {
    bool result = false;
    await ApiController.instance.request(
      url: "master/explore/posts/?q=$keyword",
      method: ApiMethod.get,
      onSuccess: (response) {
        _posts = [];
        for (var value in response.data["results"]) {
          _posts.add(Post.fromJson(value));
        }
        result = true;
      },
      onCatchDioError: (e) {
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e) {
        _apiMessage = 'مشکلی پیش آمده است';
      },
    );

    return result;
  }
}
