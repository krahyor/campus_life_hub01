import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text('Campus Life Hub', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: const Color(0xFF113F67),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                SizedBox(
                  height: 180.h,
                  child: PageView.builder(
                    itemCount: 3,
                    itemBuilder:
                        (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.blue[200],
                            image: DecorationImage(
                              image: AssetImage('assets/banner_$index.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  ),
                ),

                // Dot Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0 ? Colors.blue : Colors.grey[400],
                      ),
                    ),
                  ),
                ),

                // What's new - Announcements
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "What's new",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Announcements',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/events'),
                        child: Text(
                          'view all',
                          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 110.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 5,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder:
                        (context, index) => Container(
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4.r),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'ข่าว/ประกาศ $index',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                  ),
                ),

                // What's new - Events
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "What's new",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Events',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/events'),
                        child: Text(
                          'view all',
                          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 110.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 5,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder:
                        (context, index) => Container(
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4.r),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'กิจกรรม $index',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                  ),
                ),

                // Tools Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    'Tools',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true, // ✅ ให้ GridView ขยายตามเนื้อหา
                  physics:
                      const NeverScrollableScrollPhysics(), // ✅ ปิด scroll ของ grid
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    _buildToolButton(
                      Icons.school,
                      'ค้นหาวิชา',
                      onTap: () => Navigator.pushNamed(context, '/exampleInfo'),
                    ),
                    _buildToolButton(
                      Icons.computer,
                      'ลงทะเบียน',
                      onTap: () => Navigator.pushNamed(context, '/subject'),
                    ),
                    _buildToolButton(
                      Icons.group,
                      'Group',
                      onTap: () => Navigator.pushNamed(context, '/group'),
                    ),
                    _buildToolButton(
                      Icons.map,
                      'Map',
                      onTap: () => Navigator.pushNamed(context, '/map'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF113F67),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
