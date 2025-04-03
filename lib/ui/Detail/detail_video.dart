import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/components/post_options_popup.dart';
import 'package:fluttertest/components/share.dart';
import 'package:video_player/video_player.dart';

class RecipeVideoScreen extends StatefulWidget {
  final String recipeId;

  const RecipeVideoScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeVideoScreenState createState() => _RecipeVideoScreenState();
}

class _RecipeVideoScreenState extends State<RecipeVideoScreen> {
  late VideoPlayerController _controller;
  bool isLiked = false;
  bool isLoading = true;

  String chefName = '';
  String chefAvatar = '';
  String videoTitle = '';
  String videoTime = '';
  List<Map<String, dynamic>> steps = [];

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('recipes')
              .doc(widget.recipeId)
              .get();

      final data = doc.data();
      if (data == null) return;

      final videoUrl = data['video_url'] ?? '';
      final stepList =
          (data['steps'] as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList();

      setState(() {
        chefName = "Chef ${data['chef_id']}";
        chefAvatar = "https://i.pravatar.cc/100?u=${data['chef_id']}";
        videoTitle = data['title'] ?? '';
        videoTime = "${stepList.length * 3} phút"; // Giả sử mỗi bước ~3 phút
        steps = stepList;
        isLoading = false;
      });

      _controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    } catch (e) {
      print("❌ Error loading recipe video: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Xem Video",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () => showSharePopup(context),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio:
                              _controller.value.isInitialized
                                  ? _controller.value.aspectRatio
                                  : 16 / 9,
                          child:
                              _controller.value.isInitialized
                                  ? VideoPlayer(_controller)
                                  : Center(child: CircularProgressIndicator()),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                size: 50,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(chefAvatar),
                            radius: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            chefName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                          Text(
                            "273 Likes",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videoTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Món ăn · $videoTime",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            steps.map((step) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bước ${step['step_number']}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      step['description'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void showSharePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext ctx) => ShareBottomSheet(),
    );
  }
}
