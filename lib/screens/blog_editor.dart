import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/dummy.dart';

class BlogEditor extends StatefulWidget {
  BlogEditor({
    Key? key, required this.editorController
  }) : super(key: key);
  TextEditingController? editorController = TextEditingController();

  @override
  State<BlogEditor> createState() => _BlogEditorState();
}

class _BlogEditorState extends State<BlogEditor> {
  
  final ScrollController _controller = ScrollController();

  void _scrollToEnd() {
    var scrollPosition = _controller.position;

    if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
      _controller.animateTo(
        scrollPosition.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _printLatestValue() {
    print('${widget.editorController!.text}');
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    widget.editorController!.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
               color: Colors.white70,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Thêm nội dung",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                          
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        widget.editorController!.text = dummyPost;
                        setState(() {});
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Mẫu có sẵn"),
                    ),
                    IconButton(
                      splashRadius: 24,
                      onPressed: () {
                        widget.editorController!.clear();
                      },
                      icon: const Icon(
                        CupertinoIcons.clear,
                      ),
                    ),
                    IconButton(
                      splashRadius: 24,
                      onPressed: _scrollToEnd,
                      icon: const Icon(
                        CupertinoIcons.down_arrow,
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: TextField(
                      controller: widget.editorController,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlue,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                      onChanged: (text) {
                        widget.editorController!.text;
                        setState(() {});
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Xem trước",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: double.infinity,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: Markdown(
                      shrinkWrap: true,
                      data: widget.editorController!.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
