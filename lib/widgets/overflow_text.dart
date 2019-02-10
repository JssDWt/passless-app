import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';

class OverflowText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;
  OverflowText(
    this.text, 
    {
      @required this.maxLines, 
      this.style
    }) : assert(text != null),
         assert(maxLines > 0);

  @override
  _OverflowTextState createState() => _OverflowTextState();
}

class _OverflowTextState extends State<OverflowText> 
  with SingleTickerProviderStateMixin {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.style ?? DefaultTextStyle.of(context).style;
    var widLoc = WidgetsLocalizations.of(context);
    var loc = PasslessLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Build the textspan
        var span = TextSpan(
          text: widget.text,
          style: style,
        );

        // Use a textpainter to determine if it will exceed max lines
        var tp = TextPainter(
          maxLines: widget.maxLines,
          textAlign: widLoc.textDirection == TextDirection.ltr 
            ? TextAlign.left : TextAlign.right,
          textDirection: widLoc.textDirection,
          text: span,
        );

        // trigger it to layout
        tp.layout(maxWidth: constraints.maxWidth);

        // whether the text overflowed or not
        var exceeded = tp.didExceedMaxLines;
        
        List<Widget> columnContent = [];

        int maxLines = widget.maxLines;
        if (exceeded) {
          columnContent.add(Divider());
          if (showMore) {
            maxLines = 20;
            columnContent.add(FlatButton(
              child: Text(loc.lessButtonLabel),
              onPressed: () {
                setState(() {
                  showMore = false;                
                });
              },
            ));
          }
          else {
            columnContent.add(FlatButton(
              child: Text(loc.moreButtonLabel),
              onPressed: () {
                setState(() {
                  showMore = true;                
                });
              },
            ));
          }
        }

        columnContent.insert(
          0, 
          AnimatedSize(
            vsync: this,
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 120),
            child: Text.rich(
              span,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            )
          )
        );

        return Column(children: columnContent);
      }
    );
  }

}