import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili/utils/view_util.dart';

import '../model/profile_mo.dart';

class CourseCard extends StatelessWidget {
  final List<CourseMo> courseList;

  const CourseCard({Key? key, required this.courseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), ..._buildCourseList(context, courseList)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text('职场进阶',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          hiSpace(width: 10),
          Text('带你突破技术瓶颈',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
        ],
      ),
    );
  }

  _buildCourseList(BuildContext context, List<CourseMo> courseList) {
    var courseGroup = Map();
    courseList.forEach((course) {
      if (!courseGroup.containsKey(course.group)) {
        courseGroup[course.group] = [];
      }
      courseGroup[course.group].add(course);
    });
    double screenWidth = MediaQuery.of(context).size.width;
    return courseGroup.map((groupName, list) {
      //计算出每个卡片的宽度，20是此组件的左右外边距和，5是卡片之间的间隙
      double cardWidth =
          (screenWidth - 20 - (list.length - 1) * 5) / list.length;
      //因为下载的图片大小不相同，所以不能根据16:9直接算出图片高度，而是让图片自己计算高度
      // double cardHeight = cardWidth * (9 / 16);
      return MapEntry(
          groupName,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map<Widget>((mo) {
              return _buildCard(mo, cardWidth);
            }).toList(),
          ));
    }).values;
  }

  Widget _buildCard(CourseMo mo, double width, {double? height}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(right: 5, bottom: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: cachedImage(mo.cover ?? '', width: width, height: height),
        ),
      ),
    );
  }
}
