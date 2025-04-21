import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';

class InstagramFeed extends StatelessWidget {
  const InstagramFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Number of posts
        itemBuilder: (context, index) {
          return const InstagramPost();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class InstagramPost extends StatefulWidget {
  const InstagramPost({super.key});

  @override
  State<InstagramPost> createState() => _InstagramPostState();
}

class _InstagramPostState extends State<InstagramPost> {
  bool isLiked = false;
  bool isBioExpanded = false;
  bool isCommentSectionVisible = false;
  int currentCarouselIndex = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> comments = [
    Comment(
      username: 'user123',
      text: 'Amazing post! 😍',
      timeAgo: '2h',
      likes: 5,
    ),
    Comment(
      username: 'photoLover',
      text: 'The colors in this are incredible!',
      timeAgo: '1h',
      likes: 3,
    ),
    Comment(
      username: 'travel_enthusiast',
      text: 'Where was this taken? I need to visit!',
      timeAgo: '45m',
      likes: 7,
    ),
  ];

  final List<String> carouselItems = [
    'https://picsum.photos/id/1018/800/800', // Sample images
    'https://picsum.photos/id/1015/800/800',
    'https://picsum.photos/id/1019/800/800',
    'https://picsum.photos/id/1023/800/800',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          _buildPostHeader(),

          // Carousel Media
          _buildCarouselMedia(),

          // Post Actions
          _buildPostActions(),

          // Likes count
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '1,242 likes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Username and Caption
          _buildCaptionSection(),

          // Comments section trigger
          _buildCommentsTrigger(),

          // Expanded Comments Section
          if (isCommentSectionVisible) _buildCommentsSection(),

          // Time ago
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
            child: Text(
              '2 HOURS AGO',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage:
                NetworkImage('https://picsum.photos/id/1027/200/200'),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'username',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Location', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselMedia() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentCarouselIndex = index;
              });
            },
          ),
          items: carouselItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  item,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: DotsIndicator(
        //     dotsCount: carouselItems.length,
        //     position: currentCarouselIndex.toDouble(),
        //     decorator: DotsDecorator(
        //       color: Colors.grey.withOpacity(0.5),
        //       activeColor: Colors.blue,
        //       size: const Size.square(8.0),
        //       activeSize: const Size(8.0, 8.0),
        //       spacing: const EdgeInsets.symmetric(horizontal: 4.0),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.mode_comment_outlined),
            onPressed: () {
              setState(() {
                isCommentSectionVisible = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionSection() {
    const String fullBio =
        "This is a long caption about this amazing post. I took this while traveling last weekend. The scenery was breathtaking and I couldn't resist capturing this moment. I hope you all enjoy this as much as I did taking it! #travel #photography #nature #weekend #adventure";

    String displayBio = isBioExpanded
        ? fullBio
        : fullBio.substring(0, fullBio.length > 80 ? 80 : fullBio.length);

    if (!isBioExpanded && fullBio.length > 80) {
      displayBio += "...";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(
                  text: 'username ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: displayBio),
              ],
            ),
          ),
          if (fullBio.length > 80)
            GestureDetector(
              onTap: () {
                setState(() {
                  isBioExpanded = !isBioExpanded;
                });
              },
              child: Text(
                isBioExpanded ? 'Show less' : 'more',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentsTrigger() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isCommentSectionVisible = !isCommentSectionVisible;
          });
        },
        child: Text(
          'View all ${comments.length} comments',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment list
          ...comments.map((comment) => _buildCommentItem(comment)),

          // Add comment section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage('https://picsum.photos/id/1027/200/200'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        comments.add(Comment(
                          username: 'currentUser',
                          text: _commentController.text,
                          timeAgo: 'Just now',
                          likes: 0,
                        ));
                        _commentController.clear();
                      });
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(
                'https://picsum.photos/id/${1000 + comments.indexOf(comment)}/200/200'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '${comment.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: comment.text),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 16),
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class Comment {
  final String username;
  final String text;
  final String timeAgo;
  final int likes;

  Comment({
    required this.username,
    required this.text,
    required this.timeAgo,
    required this.likes,
  });
}
