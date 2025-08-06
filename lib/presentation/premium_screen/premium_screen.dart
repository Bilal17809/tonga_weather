import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tonga_weather/core/theme/app_theme.dart';
import '../../core/local_storage/local_storage.dart';
import '../remove_ads_contrl/remove_ads_contrl.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

final bool _kAutoConsume = Platform.isIOS || true;
const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = '';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
];
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isSwitch = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  final RemoveAds removeAdsController = Get.put(RemoveAds());

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      if (!context.mounted) return;
      Text("No Internet Available");
    }
  }



  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (Object error) {
        print('Error in purchase stream: $error');
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        setState(() {
          _purchasePending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase stream error: ${error.toString()}')),
        );
      },
    );
    initStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }


  Column _buildProductList(double screenWidth, double screenHeight) {
    double horizontalPadding = screenWidth * 0.02;
    double verticalPadding = screenHeight * 0.01;
    bool isSmallScreen = screenWidth < 600;

    final Map<String, PurchaseDetails> purchases = {
      for (var purchase in _purchases) purchase.productID: purchase
    };
    bool isSubscribed = removeAdsController.isSubscribedGet.value;
    return Column(
      children: _products.map((product) {
        final purchase = purchases[product.id];
        return isSubscribed
            ? Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: const Text(
            "You are on the ads-free version!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        )
            : Card(
          color:Colors.green.shade300,
          elevation: 1.0,
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: ListTile(
            title: Text(
              'Life Time Subscription',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:isSmallScreen? 16:screenHeight*0.02,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              product.description,
              style: TextStyle(
                  fontSize:isSmallScreen? 14:screenHeight*0.02,
                  color:  Colors.white),
            ),
            trailing: Text(
              product.price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:  Colors.white,
                fontSize: isSmallScreen?16:screenHeight*0.02,
              ),
            ),
            onTap: () {
              if (mounted) {
                _showPurchaseDialog(context, product, purchase);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showPurchaseDialog(
      BuildContext context, ProductDetails product, PurchaseDetails? purchase) async {
    final bool? confirmPurchase = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Confirm Purchase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Are you sure you want to buy:',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: ${product.price}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false); // User cancels
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 3,
                          ),
                          child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (confirmPurchase == true) {
      await _buyProduct(product, purchase);
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_queryProductError != null) {
      return Center(child: Text(_queryProductError!));
    }
    final List<Map<String, dynamic>> items = [
      {'icon': 'assets/images/Group-2.png', 'text': 'Ask AI'},
      {'icon': 'assets/images/education.png', 'text': 'Learn Grammar'},
      {'icon': 'assets/trial/regulation.png', 'text': 'Quizzes'},
      {'icon': 'assets/trial/interactive.png', 'text': 'Translator'},
    ];
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          bool isSmallScreen = width < 600;

          return SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Top green area
                      Container(
                        height: height * 0.32,
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(200),
                        ),
                      ),
                      // White curved area
                      Container(
                        height: height * 0.19,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, -100),
                              blurRadius: 110,
                              spreadRadius: 90,
                            ),
                          ],
                        ),
                      ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height:height*0.03),
                            SizedBox(
                              height: isSmallScreen ? 100 : height * 0.16,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width: width * 0.4,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      padding: const EdgeInsets.all(8),
                                      decoration: roundedDecor(context),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              items[index]['icon'],
                                              width: isSmallScreen ? 55 : height * 0.08,
                                              height: isSmallScreen ? 55 : height * 0.08,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(height: 6),
                                            Flexible(
                                              child: Text(
                                                items[index]['text'],
                                                style: TextStyle(
                                                  fontSize: isSmallScreen ? 12 : height * 0.016,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                             SizedBox(height:height*0.04),
                            _buildProductList(width,height),
                            Column(
                              children: [
                                const Text(
                                    '>> Cancel anytime at least 24 hours before renewal',
                                    style:TextStyle(color: Colors.black,fontSize:14)
                                ),
                                SizedBox(height:height*0.03,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: const Text("Privacy | Terms"),
                                      onTap:(){
                                        // Get.to(TermOfUseScreen());
                                      },
                                    ),
                                    const Text("Cancel Anytime"),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Top buttons
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _glassButton(icon: Icons.clear, onTap: () => Navigator.of(context).pop()),
                        _glassButton(
                          text: "Restore",
                          width: 70,
                          onTap: _restorePurchases,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: width * 0.08,
                    right: width * 0.08,
                    top: height * 0.36,
                    child: const Text(
                      "Get Unlimited Access",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: width * 0.08,
                    right: width * 0.08,
                    top: height * 0.42,
                    child: const Text(
                      "Accessible anytime, anywhere for flexible learning.",
                      style: TextStyle(color: Colors.green, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Image
                  // Positioned(
                  //   top: height * 0.02,
                  //   left: width * 0.20,
                  //   right: width * 0.20,
                  //   child: Image.asset(
                  //     Assets.premiumscreenpic.path,
                  //     height: height * 0.34,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),

                  Positioned(
                    left: width * 0.65,
                    right: width * 0.01,
                    top: height * 0.68,
                    child: Image.asset("assets/images/offer.png",height:65,width:65,),
                  ),

                  if (_purchasePending)
                    const Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(dismissible: false, color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Connecting to store...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        changeSubscriptionParam: purchase != null && purchase is GooglePlayPurchaseDetails
            ? ChangeSubscriptionParam(
          oldPurchaseDetails: purchase,
        )
            : null,
      );
      if (product.id == _kConsumableId) {
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }

    } catch (e) {
      print('Immediate purchase initiation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate purchase: ${e.toString()}')),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> detailsList) async {
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else if (details.status == PurchaseStatus.error) {
        setState(() => _purchasePending = false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${details.error?.message ?? "Unknown error"}')),
        );
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        setState(() => _purchasePending = false);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        final prefs = LocalStorage();
        await prefs.setBool('SubscribeAiGrammar', true);
        await prefs.setString('subscriptionAiId', details.productID);
         await prefs.getBool('SubscribeTonga');
         await prefs.getString('subscriptionAiId');

        removeAdsController.isSubscribedGet(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription purchased successfully!')),
        );

        if (details.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(details);
        }
      }
      if (details.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(details);
      }
    }
  }

  Future<void> _restorePurchases() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store is not available!')),
      );
      return;
    }
    setState(() {
      _purchasePending = true;
    });
    // Show a restoring loader similar to _buyProduct
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Restoring purchases...'),
              ],
            ),
          ),
        );
      },
    );
    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds:15), () {
        if (_purchasePending) {
          setState(() {
            _purchasePending = false;
          });
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restore timed out or no purchases found.')),
          );
        }
      });

    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during restore: ${e.toString()}')),
      );
    }
  }
  Widget _glassButton({
    IconData? icon,
    String? text,
    double width = 30,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 34,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.6),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: 18)
              : Text(
            text ?? "",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
