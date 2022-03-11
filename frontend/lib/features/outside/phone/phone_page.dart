import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rye/features/outside/phone/tabs/dial_tab.dart';
import 'package:rye/features/outside/phone/tabs/topic_tab.dart';
import 'package:rye/features/outside/phone/tabs/voicemail_tab.dart';
import 'providers.dart';

class PhonePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = [DialTab(), TopicTab(), VoiceMailTab()];
    final page = ref.watch(pageProvider.state).state;
    PageController pageController = usePageController();

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.brown,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.bounceOut);
        },
        items: [
          BottomNavigationBarItem(
              tooltip: "call", label: "call", icon: Icon(LineIcons.braille)),
          BottomNavigationBarItem(
              tooltip: "topic",
              label: "topic",
              icon: Icon(LineIcons.quoteLeft)),
          BottomNavigationBarItem(
              tooltip: "voicemail",
              label: "voicemail",
              icon: Icon(LineIcons.voicemail)),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (BuildContext context, int index) {
          return pages[index % pages.length];
        },
        onPageChanged: (int index) {
          ref.read(pageProvider.state).state = index % pages.length;
        },
      ),
    );
  }
}
