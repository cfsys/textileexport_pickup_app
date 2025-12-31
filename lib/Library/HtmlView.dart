
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';

const htmlcontent=
''' <div class="tradingview-widget-container">
  <div class="tradingview-widget-container__widget"></div>
  <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-symbol-overview.js" async>
  {
  "symbols": [
  [
  "Apple",
  "AAPL|1D"
  ],
  [
  "Google",
  "GOOGL|1D"
  ],
  [
  "Microsoft",
  "MSFT|1D"
  ]
  ],
  "chartOnly": true,
  "width": "100%",
  "height": "100%",
  "locale": "en",
  "colorTheme": "light",
  "autosize": true,
  "showVolume": false,
  "showMA": false,
  "hideDateRanges": false,
  "hideMarketStatus": false,
  "hideSymbolLogo": false,
  "scalePosition": "right",
  "scaleMode": "Normal",
  "fontFamily": "-apple-system, BlinkMacSystemFont, Trebuchet MS, Roboto, Ubuntu, sans-serif",
  "fontSize": "10",
  "noTimeScale": false,
  "valuesTracking": "1",
  "changeMode": "price-and-percent",
  "chartType": "area",
  "maLineColor": "#2962FF",
  "maLineWidth": 1,
  "maLength": 9,
  "lineWidth": 2,
  "lineType": 0,
  "dateRanges": [
  "1d|1",
  "1m|30",
  "3m|60",
  "12m|1D",
  "60m|1W",
  "all|1M"
  ]
  }
  </script>
  </div>''';

const candleHtmlContent=
    '''
<div class="tradingview-widget-container" style="height:200%;width:200%" spellcheck="true">
  <div class="tradingview-widget-container__widget" style="height:calc(200% );width:200%"></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
  {
  "height":400,
  "autosize": true,
  "symbol": "BINANCE:BTCUSDT",
  "timezone": "Etc/UTC",
  "theme": "light",
  "style": "1",
  "locale": "en",
  "withdateranges": false,
  "range": "YTD",
  "allow_symbol_change": true,
  "calendar": false,
  "support_host": "https://www.tradingview.com"
}
  </script>
</div>
    ''';

class HtmlView extends StatefulWidget {
  const HtmlView({super.key});

  @override
  State<HtmlView> createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {

  HtmlViewerController _controller = HtmlViewerController();

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InAppWebView(
          initialOptions: InAppWebViewGroupOptions(

        ),
          onWebViewCreated: (InAppWebViewController controller) async {
              controller.loadUrl(
                urlRequest: URLRequest(
                url:WebUri.uri(Uri.dataFromString(
                  "dddddddddddd",
                  mimeType: 'text/html',
                  encoding: Encoding.getByName('utf-8'),
                  ),
                )
                ),
              );
          },
        ),
          const HtmlContentViewer(
                 htmlContent:candleHtmlContent,
                  // maxContentHeightForAndroid: height,
                  // initialContentHeight: height,
                  // initialContentWidth: width,
          ),
        ],
      ),
    );
  }
}
