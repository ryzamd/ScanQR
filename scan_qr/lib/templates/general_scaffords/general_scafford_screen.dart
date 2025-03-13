import 'package:flutter/material.dart';
import 'package:scan_qr/utilites/contants/style_contants.dart';

/// GeneralScreenScaffold là widget chung cho tất cả các màn hình,
/// nó tạo ra một Scaffold với AppBar có tiêu đề tùy chỉnh, nút back (nếu cần)
/// và các phần tùy chọn khác.
class GeneralScreenScaffold extends StatelessWidget {
  final Widget? title;
  final bool showBackButton;
  final bool isSubScreen;
  final bool? resizeToAvoidBottomInset;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;

  const GeneralScreenScaffold({
    super.key,
    this.title,
    this.showBackButton = false,
    required this.body,
    this.bottomNavigationBar,
    this.actions,
    required this.isSubScreen,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) {
    final Widget? leadingButton =
        showBackButton && Navigator.canPop(context)
            ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
            : null;

    final List<Widget> actionButtons =
        isSubScreen
            ? <Widget>[
              if (actions != null) ...actions!,
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 1),
                onPressed: () => Navigator.pop(context),
              ),
            ]
            : (actions ?? <Widget>[]);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: leadingButton,
        title: title,
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        backgroundColor: ColorsConstants.primaryColor,
        toolbarHeight: 50,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: actionButtons,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class GeneralScreenScaffoldHeaderIcons extends StatefulWidget {
  final Text? title;
  final bool showBackButton;
  final TextStyle? textStyle;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? sizedBox;
  final AppBar? genAppBar;
  final List<Widget>? actions;

  const GeneralScreenScaffoldHeaderIcons({
    super.key,
    this.title,
    this.genAppBar,
    this.sizedBox,
    this.textStyle,
    this.showBackButton = false,
    required this.body,
    this.bottomNavigationBar,
    this.actions,
  });

  @override
  State<GeneralScreenScaffoldHeaderIcons> createState() =>
      _GeneralScreenScaffoldHeaderIconsState();
}

class _GeneralScreenScaffoldHeaderIconsState
    extends State<GeneralScreenScaffoldHeaderIcons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.genAppBar ??
          AppBar(
            leading:
                widget.showBackButton && Navigator.canPop(context)
                    ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                    : null,
            title: widget.title,
            centerTitle: true,
            backgroundColor: Colors.blue,
            toolbarHeight: 50,
            automaticallyImplyLeading: widget.showBackButton,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: widget.actions,
          ),

      body: SafeArea(child: widget.body),

      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}

class SubScreenScafford extends StatefulWidget {
  final bool isSubScreen;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;

  const SubScreenScafford({
    super.key,
    required this.isSubScreen,
    required this.body,
    this.bottomNavigationBar,
    this.actions,
  });

  @override
  State<SubScreenScafford> createState() => _SubScreenScaffordState();
}

class _SubScreenScaffordState extends State<SubScreenScafford> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.body),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
