import 'package:get/get.dart';

import '/controllers/api_controller.dart';
import '/models/like.dart';
import '/models/post.dart';
import '/models/post_comment.dart';
import '/res/enums/api_method.dart';

class PostController extends GetxController{
  List<Post> _posts = [];

  String _apiMessage = "";

  String get apiMessage => _apiMessage;

  List<Post> get posts => _posts;

  Future<bool> getPosts(int profileId) async {
    bool result = false;

    await ApiController.instance.request(url: "masters/posts/?profile_id=$profileId}",
      method: ApiMethod.get,
      onSuccess: (response){
        _posts = [];
        for(var item in response.data){
          _posts.add(Post.fromJson(item));
        }
        result = true;
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e){
        _apiMessage = 'مشکلی پیش آمده است';
      }
    );

    return result;
  }

  Future<Post?> getPostDetails(int postId) async {
    Post? post;

    await ApiController.instance.request(
      url: "master/posts/$postId",
      method: ApiMethod.get,
      onSuccess: (response){
        post = Post.fromJson(response.data);
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e){
        _apiMessage = 'مشکلی پیش آمده است';
      }
    );

    return post;
  }

  Future<bool> editPost(int postId, String? caption) async {
    Map payload = {
      "caption": caption,
    };

    bool result = false;

    await ApiController.instance.request(
        url: "master/posts/$postId/",
        method: ApiMethod.patch,
        data: caption!=null ? payload : null,
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<bool> deletePost(int postId) async {
    bool result = false;

    await ApiController.instance.request(
        url: "master/posts/$postId/",
        method: ApiMethod.delete,
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<List<PostComment>?> getPostComments(int postId) async {
    List<PostComment>? postComments;
    await ApiController.instance.request(
      url: "master/comments/?profile_post_id=$postId",
      method: ApiMethod.get,
      onSuccess: (response){
        postComments = [];
        for(var item in response.data){
          postComments?.add(PostComment.fromJson(item));
        }
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e){
        _apiMessage = 'مشکلی پیش آمده است';
      }
    );

    return postComments;
  }

  Future<PostComment?> getCommentDetail(int commentId) async {
    PostComment? postComment;
    
    await ApiController.instance.request(
      url: "master/comments/$commentId",
      method: ApiMethod.get,
      onSuccess: (response){
        postComment = PostComment.fromJson(response.data);
      },
      onCatchDioError: (e){
        _apiMessage = e.response?.data['detail'] ?? '';
      },
      onCatchError: (e){
        _apiMessage = 'مشکلی پیش آمده است';
      }
    );

    return postComment;
  }

  Future<bool> create(
      int postId, String comment) async {
    bool result = false;

    await ApiController.instance.request(
        url: "master/comments/",
        method: ApiMethod.post,
        data: {
          "post": postId,
          "comment": comment,
        },
        onSuccess: (response){
          _apiMessage = response.data["detail"];
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<bool> editPostComments(
      int commentId, String comment) async {

    bool result = false;
    await ApiController.instance.request(
        url: "master/comments/$commentId/",
        method: ApiMethod.patch,
        data: {
          "comment": comment,
        },
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<bool> deletePostComment(int commentId) async {
    bool result = false;
    await ApiController.instance.request(
        url: "master/comments/$commentId/",
        method: ApiMethod.delete,
        onSuccess: (response){
          result = true;
          _apiMessage = response.data["detail"] ?? '';
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<List<Like>?> getPostLikes(int postId) async {
    List<Like>? postLikes;
    await ApiController.instance.request(
        url: "master/likes/?profile_post_id=$postId",
        method: ApiMethod.get,
        onSuccess: (response){
          postLikes = [];
          for(var item in response.data){
            postLikes?.add(Like.fromJson(item));
          }
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

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
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }

  Future<bool> deletePostLikes(int postId) async {
    bool result = false;
    await ApiController.instance.request(
        url: "master/likes/$postId/",
        method: ApiMethod.delete,
        onSuccess: (response){
          result = true;
        },
        onCatchDioError: (e){
          _apiMessage = e.response?.data['detail'] ?? '';
        },
        onCatchError: (e){
          _apiMessage = 'مشکلی پیش آمده است';
        }
    );

    return result;
  }
}