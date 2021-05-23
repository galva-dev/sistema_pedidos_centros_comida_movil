import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 50;
const double CAMERA_BEARING = 30;
const String MAP_STYLE = '''[
{
"elementType": "geometry",
"stylers": [
{
"color": "#1d2c4d"
}
]
},
{
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#8ec3b9"
}
]
},
{
"elementType": "labels.text.stroke",
"stylers": [
{
"color": "#1a3646"
}
]
},
{
"featureType": "administrative.country",
"elementType": "geometry.stroke",
"stylers": [
{
"color": "#4b6878"
}
]
},
{
"featureType": "administrative.land_parcel",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#64779e"
}
]
},
{
"featureType": "administrative.province",
"elementType": "geometry.stroke",
"stylers": [
{
"color": "#4b6878"
}
]
},
{
"featureType": "landscape.man_made",
"elementType": "geometry.stroke",
"stylers": [
{
"color": "#334e87"
}
]
},
{
"featureType": "landscape.natural",
"elementType": "geometry",
"stylers": [
{
"color": "#023e58"
}
]
},
{
"featureType": "poi",
"elementType": "geometry",
"stylers": [
{
"color": "#283d6a"
}
]
},
{
"featureType": "poi",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#6f9ba5"
}
]
},
{
"featureType": "poi",
"elementType": "labels.text.stroke",
"stylers": [
{
"color": "#1d2c4d"
}
]
},
{
"featureType": "poi.business",
"stylers": [
{
"visibility": "off"
}
]
},
{
"featureType": "poi.park",
"elementType": "geometry.fill",
"stylers": [
{
"color": "#023e58"
}
]
},
{
"featureType": "poi.park",
"elementType": "labels.text",
"stylers": [
{
"visibility": "off"
}
]
},
{
"featureType": "poi.park",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#3C7680"
}
]
},
{
"featureType": "road",
"elementType": "geometry",
"stylers": [
{
"color": "#304a7d"
}
]
},
{
"featureType": "road",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#98a5be"
}
]
},
{
"featureType": "road",
"elementType": "labels.text.stroke",
"stylers": [
{
"color": "#1d2c4d"
}
]
},
{
"featureType": "road.highway",
"elementType": "geometry",
"stylers": [
{
"color": "#2c6675"
}
]
},
{
"featureType": "road.highway",
"elementType": "geometry.stroke",
"stylers": [
{
"color": "#255763"
}
]
},
{
"featureType": "road.highway",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#b0d5ce"
}
]
},
{
"featureType": "road.highway",
"elementType": "labels.text.stroke",
"stylers": [
{
"color": "#023e58"
}
]
},
{
"featureType": "transit",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#98a5be"
}
]
},
{
"featureType": "transit",
"elementType": "labels.text.stroke",
"stylers": [
{
"color": "#1d2c4d"
}
]
},
{
"featureType": "transit.line",
"elementType": "geometry.fill",
"stylers": [
{
"color": "#283d6a"
}
]
},
{
"featureType": "transit.station",
"elementType": "geometry",
"stylers": [
{
"color": "#3a4762"
}
]
},
{
"featureType": "water",
"elementType": "geometry",
"stylers": [
{
"color": "#0e1626"
}
]
},
{
"featureType": "water",
"elementType": "labels.text.fill",
"stylers": [
{
"color": "#4e6d70"
}
]
}
]''';
const double PIN_VISIBLE_POSITION = 10;
const double PIN_INVISIBLE_POSITION = -200;

class MapPage extends StatefulWidget {
  FoodCenter foodCenter;

  MapPage({this.foodCenter});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Set<Marker> _markers = Set<Marker>();
  final user = FirebaseAuth.instance.currentUser;
  double pinPillPosition = PIN_VISIBLE_POSITION;

  LatLng currentLocation = LatLng(-16.4994641047607, -68.12381440408689);
  LatLng destinationLocation = LatLng(-16.499513253747285, -68.12448863602962);

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylinesCoordinates = [];
  PolylinePoints polylinesPoints;

  @override
  void initState() {
    super.initState();
    //inicializamos las polilineas
    polylinesPoints = PolylinePoints();
    setInitialLocation();
  }

  void setInitialLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      destinationLocation =
          LatLng(
              this.widget.foodCenter.latitud, this.widget.foodCenter.longitud);
    });
    print("UBICACION LOCATOR");
    print("$currentLocation");
    print("$destinationLocation");
    showPinsOnMap();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: currentLocation);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: true,
              trafficEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              polylines: _polylines,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(MAP_STYLE);
                _controller = controller;
              },
              onTap: (LatLng loc) {
                setState(() {
                  this.pinPillPosition = PIN_INVISIBLE_POSITION;
                });
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: (){
                _controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: currentLocation, zoom: 16, bearing: 90, tilt: 55)));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset.zero)
                    ]),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(user.photoURL),
                              fit: BoxFit.cover),
                          border: Border.all(color: Colors.green, width: 2)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors
                                  .grey),
                            ),
                            Text(
                              'Mi ubicacion',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors
                                  .green),
                            )
                          ],
                        )),
                    Icon(
                      FontAwesomeIcons.locationArrow,
                      size: 20,
                      color: Colors.green,
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: 0,
            right: 50,
            bottom: this.pinPillPosition,
            child: InkWell(
              onTap: (){
                _controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: destinationLocation, zoom: 16, bearing: 90, tilt: 55)));
              },
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset.zero)
                    ]),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  this.widget.foodCenter.logo,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                            clipBehavior: Clip.none,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this.widget.foodCenter.nombre,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  this.widget.foodCenter.descripcion,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  this.widget.foodCenter.direccion,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.locationArrow,
                            color: Colors.redAccent,
                            size: 20,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showPinsOnMap() {
    setState(() {
      print("UBICACION DEL MARKER");
      print("$currentLocation");
      print("$destinationLocation");
      _markers.add(Marker(
          markerId: MarkerId('SourcePin'),
          position: currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));

      _markers.add(Marker(
          markerId: MarkerId('DestinationPin'),
          position: destinationLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            setState(() {
              this.pinPillPosition = PIN_VISIBLE_POSITION;
            });
            //setPolylines();
          }));
    });
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: currentLocation, zoom: 16, bearing: 90, tilt: 45)));
  }

  void setPolylines() async {
    PolylineResult result = await polylinesPoints.getRouteBetweenCoordinates(
        "AIzaSyCWdkuc3sr6isHHZL65IM10N2hXkmNsRkY",
        PointLatLng(currentLocation.longitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 'OK') {
      result.points.forEach((element) {
        polylinesCoordinates.add(LatLng(element.latitude, element.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            polylineId: PolylineId('Ruta'),
            width: 10,
            color: Colors.cyanAccent,
            points: polylinesCoordinates));
      });
    }
  }
}
