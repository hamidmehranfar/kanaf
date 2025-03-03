import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../res/enums/media_type.dart';
import '/controllers/api_controller.dart';
import '/models/like.dart';
import '/models/post.dart';
import '/models/post_comment.dart';
import '/res/enums/api_method.dart';

class PostController extends GetxController {
  List<Post> _posts = [];

  String _apiMessage = "";

  String get apiMessage => _apiMessage;

  List<Post> get posts => _posts;

  List<String> _networkImages = [];
  List<(File?, MediaType?)> _images = List.generate(6, (index) => (null, null));
  List<bool> _picturesLoading = List.generate(6, (index) => false);

  bool _createPostLoading = false;

  List<String> get networkImages => _networkImages;

  List<(File?, MediaType?)> get images => _images;

  List<bool> get picturesLoading => _picturesLoading;

  bool get createPostLoading => _createPostLoading;

  set createPostLoading(bool loading) => _createPostLoading = loading;

  void initPostValues() {
    _images = List.generate(6, (index) => (null, null));
    _picturesLoading = List.generate(6, (index) => false);
    _networkImages = [];

    _createPostLoading = false;
  }

  Future<bool> getPosts(int profileId) async {
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
        });

    return result;
  }

  Future<Post?> getPostDetails(int postId) async {
    Post? post;

    await ApiController.instance.request(
        url: "master/posts/$postId",
        method: ApiMethod.get,
        onSuccess: (response) {
          post = Post.fromJson(response.data);
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return post;
  }

  Future<bool> createPost() async {
    bool result = false;

    List<(File, MediaType)> selectedImages = [];
    for (var image in _images) {
      if (image.$1 != null && image.$2 != null) {
        selectedImages.add((image.$1!, image.$2!));
      }
    }

    dio.FormData formData = dio.FormData.fromMap({
      "caption": 'test',
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

    // dio.FormData formData = dio.FormData.fromMap({
    //   "caption": 'test',
    //   if(selectedImages.isNotEmpty)
    //   "items": [
    //     for (int i = 0; i < selectedImages.length; i++)
    //       {
    //         "item_type": "0",
    //         "file": await dio.MultipartFile.fromFile(
    //           selectedImages[i].path,
    //           filename: selectedImages[i].path.split('/').last,
    //         ),
    //       }
    //   ],
    // });

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

  bool checkIsItemsChange(Post post) {
    if (_images.isNotEmpty) return true;

    List<String> urls = [];

    for (var item in post.items) {
      urls.add(item.file);
    }

    for (var url in _networkImages) {
      if (!urls.contains(url)) {
        return true;
      }
    }

    return false;
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

  Future<bool> editPostCaption(int postId, String? caption) async {
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

  Future<bool> deletePost(int postId) async {
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
        });

    return result;
  }

  Future<List<PostComment>?> getPostComments(int postId) async {
    List<PostComment>? postComments;
    await ApiController.instance.request(
        url: "master/comments/?profile_post_id=$postId",
        method: ApiMethod.get,
        onSuccess: (response) {
          postComments = [];
          for (var item in response.data) {
            postComments?.add(PostComment.fromJson(item));
          }
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

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
          _apiMessage = response.data["detail"];
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
          for (var item in response.data) {
            postLikes?.add(Like.fromJson(item));
          }
        },
        onCatchDioError: (e) {
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e) {
          _apiMessage = 'مشکلی پیش آمده است';
        });

    return postLikes;
  }

  Future<bool> createPostLikes(int postId) async {
    bool result = false;
    await ApiController.instance.request(
        url: "master/likes/",
        data: {
          "post": postId,
        },
        method: ApiMethod.post,
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
        });

    return result;
  }
}
