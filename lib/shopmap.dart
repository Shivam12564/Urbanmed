//api key baki , permission baki, marker nu baki , error solve,
// button banavanu baki on method saathe to add data to shop collection
// shop registrtion pachi aa page mukvanu to get the accurate long, lat of that locaton and add that data
// to the firebase through on tap method on the button linked with the firebase
// onTap vadi method ne button ma mukvani.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbanmed/retailer_login.dart';

class ShopMap extends StatefulWidget {
  @override
  _ShopMapState createState() => _ShopMapState();
}

class _ShopMapState extends State<ShopMap> {
  GoogleMapController? googleMapController;
  Position? position;
  String? addressLocation;
  String? country;
  String? postalCode;
  var lat;
  var long;
  String? updateid;
  bool isAdd = true;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: addressLocation));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      position = currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  List<Marker> myMarker = [];

  handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
    });
  }

  Future createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Location !!"),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Container(
          child: Column(children: [
            SizedBox(
              height: 600.0,
              child: GoogleMap(
                  onTap: (tapped) async {
                    lat = tapped.latitude;
                    long = tapped.longitude;
                    // final coordinate = new geoco.Coordinates(tapped.latitude, tapped.longitude);
                    // var address = await geoco.Geocoder.local.findAddressesFromCoordinates(coordinate);
                    // var firstAddress = address.first;
                    var firstAddress = "";
                    getMarkers(tapped.latitude, tapped.longitude);
                    // await FirebaseFirestore.instance
                    //     .collection('Retailer')
                    //     .add({
                    //   'latitude': tapped.latitude,
                    //   'longitude': tapped.longitude,
                    //   //'Address': tapped.addressLine,
                    //   'Country': firstAddress.countryName,
                    //   'postalcode': firstAddress.postalCode,
                    // });
                    setState(() {
                      // country = firstAddress.countryName;
                      // postalCode = firstAddress.postalCode;
                      // addressLocation = firstAddress.addressLine;
                    });
                  },
                  mapType: MapType.hybrid,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      googleMapController = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(target: LatLng(position!.latitude.toDouble(), position!.longitude.toDouble()), zoom: 15.0),
                  markers: Set<Marker>.of(markers.values)),
            ),
            SizedBox(height: 20),
            Container(
              child: ElevatedButton(
                  //color: Colors.pink[400],
                  child: Text(
                    'Register Shop',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)
                          )
                      )
                  ),
                  onPressed: () async {
                    if (isAdd) {
                      Map<String, dynamic> data = {
                        'Longitude': long,
                        'Latitude': lat,
                      };

                      var query = await FirebaseFirestore.instance.collection('Retailer').where('email', isEqualTo: firebaseUser!.email).get();
                      if (query.docs.isNotEmpty) {
                        await FirebaseFirestore.instance.collection('Retailer').doc(query.docs[0].id).collection('Shopdata').add(data);
                        print(data);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => RetailLogin(firebaseUser!.uid),
                          ),
                        );
                      } else {
                        //updateid
                        Map<String, dynamic> data = {'Latitude': lat, 'Longitude': long};

                        var query = await FirebaseFirestore.instance.collection('Retailer').where('email', isEqualTo: firebaseUser!.email).get();
                        if (query.docs.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('Retailer')
                              .doc(query.docs[0].id)
                              .collection('Shopdata')
                              .doc(updateid)
                              .update(data);
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  }),
            ),
            Text('Address : $addressLocation'),
            Text('PinCode : $postalCode'),
            Text('Country : $country'),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
