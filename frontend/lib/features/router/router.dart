import 'package:flutter/material.dart';
import 'package:rye/app_bak/ui/phone/phone_page.dart';

class Page {
  final String title;
  final String author;
  Page(this.title, this.author, {ValueKey<Page>? key});
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // Handle '/Page/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'Page') return AppRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return AppRoutePath.unknown();
      return AppRoutePath.details(id);
    }

    // Handle unknown routes
    return AppRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/Page/${path.id}');
    }
    return null;
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Page? _selectedPage;
  bool show404 = false;

  List<Page> pages = [
    Page('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Page('Too Like the Lightning', 'Ada Palmer'),
    Page('Kindred', 'Octavia E. Butler'),
  ];

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath get currentConfiguration {
    if (show404) {
      return AppRoutePath.unknown();
    }
    return _selectedPage == null
        ? AppRoutePath.home()
        : AppRoutePath.details(pages.indexOf(_selectedPage!));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('BooksListPage'),
          child: ListScreen(
            pages: pages,
            onTapped: _handleBookTapped,
          ),
        ),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedPage != null)
          MaterialPage(child: PhonePage())
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedPage to null
        _selectedPage = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _selectedPage = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.id! < 0 || path.id! > pages.length - 1) {
        show404 = true;
        return;
      }

      _selectedPage = pages[path.id!];
    } else {
      _selectedPage = null;
    }

    show404 = false;
  }

  void _handleBookTapped(Page page) {
    _selectedPage = page;
    notifyListeners();
  }
}

class AppRoutePath {
  final int? id;
  final bool isUnknown;

  AppRoutePath.home()
      : id = null,
        isUnknown = false;

  AppRoutePath.details(this.id) : isUnknown = false;

  AppRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class ListScreen extends StatelessWidget {
  final List<Page> pages;
  final ValueChanged<Page> onTapped;

  ListScreen({
    required this.pages,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var Page in pages)
            ListTile(
              title: Text(Page.title),
              subtitle: Text(Page.author),
              onTap: () => onTapped(Page),
            )
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Page page;
  DetailScreen({
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page != null) ...[
              Text(page.title, style: Theme.of(context).textTheme.headline6),
              Text(page.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}
