import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.person_pin)),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26, width: 1),
                              borderRadius: BorderRadius.circular(60)),
                          height: 60,
                          width: 300,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "What's on your mind ..."),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black12,
              height: 5,
            ),
            taskNewFeed(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                color: Colors.black12,
                height: 10,
              ),
            ),
            stories(),
            Divider(
              color: Colors.black12,
              height: 5,
            ),
            post(),
          ],
        ));
  }

  Widget taskNewFeed() {
    return Container(
      height: 40,
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.video_camera_back), Text('Live')],
              )),
          VerticalDivider(
            width: 1,
            color: Colors.black12,
            thickness: 1,
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.photo_library), Text('Photo')],
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.black12,
            thickness: 1,
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.location_on), Text('Check in')],
            ),
          ),
        ],
      ),
    );
  }

  Widget stories() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Container(width: 100,
                height: 160,
                decoration: BoxDecoration(
                    boxShadow: [],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1591154669695-5f2a8d20c089?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'))),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Name of ....',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget post() {
    return ListView.builder(
      shrinkWrap: true, // Đảm bảo ListView không chiếm toàn bộ chiều cao
      physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn của ListView.builder
      itemCount: 10, // Đặt số lượng phần tử theo nhu cầu của bạn
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [CircleAvatar(), Text('  Name $index')]),
              Text(
                'Post #$index',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              ReadMoreText(
                'Nếu chưa có ứng dụng Flutter, bạn có thể hoàn thành hướng dẫn Lấy Đã bắt đầu: Chạy thử để tạo một ứng dụng Flutter mới bằng trình chỉnh sửa hoặc IDE mà bạn ưa thích.',
                trimLines: 3,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Read more',
                trimExpandedText: 'Show less',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
              ),
              Image(image: NetworkImage('https://images.unsplash.com/photo-1517404215738-15263e9f9178?q=80&w=4114&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              )),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Row(children: [
                  Icon(Icons.favorite),Text('11')
                ],),
              )
            ],
          ),
        );
      },
    );
  }

}