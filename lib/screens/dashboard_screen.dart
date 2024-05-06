import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/fragment/all_news_fragment.dart';
import 'package:stock_investment_flutter/fragment/home_fragment.dart';
import 'package:stock_investment_flutter/fragment/markets_fragment.dart';
import 'package:stock_investment_flutter/fragment/portfolio_fragment.dart';
import 'package:stock_investment_flutter/fragment/profile_fragment.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/utils/colors.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';
import 'package:stock_investment_flutter/utils/images.dart';


import '../model/user.dart';

class DashBoardScreen extends StatefulWidget {
  User user=new User.withoutAnyInfo();

  DashBoardScreen(User user){
    this.user = user;
  }
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState(user);
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  User user=new User.withoutAnyInfo();
  
  _DashBoardScreenState(User user){
    this.user=user;
  }

  int _selectedIndex = 0;

  var _pages = [];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: boldTextStyle(size: 14),
      selectedItemColor: appStore.isDarkModeOn ? white : primaryColor,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ic_home.iconImage(size: 22),
          label: 'Home',
          activeIcon: ic_fill_home.iconImage(color: appStore.isDarkModeOn ? white : primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: ic_news.iconImage(size: 22),
          label: 'News',
          activeIcon: ic_fill_news.iconImage(color: appStore.isDarkModeOn ? white : primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: ic_market.iconImage(size: 22),
          label: 'Markets',
          activeIcon: ic_fill_market.iconImage(color: appStore.isDarkModeOn ? white : primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: ic_portfolio.iconImage(size: 22),
          label: 'Portfolio',
          activeIcon: ic_fill_portfolio.iconImage(color: appStore.isDarkModeOn ? white : primaryColor, size: 22),
        ),
        BottomNavigationBarItem(
          icon: ic_profile.iconImage(size: 22),
          label: 'Profile',
          activeIcon: ic_fill_profile.iconImage(color: appStore.isDarkModeOn ? white : primaryColor, size: 22),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);
    
    _pages = [
    HomeFragment(user),
    AllNewsFragment(),
    MarketFragment(user),
    PortfolioFragment(this.user),
    ProfileFragment(user),
  ];
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }


  

 
  
}
