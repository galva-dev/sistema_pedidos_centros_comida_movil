import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:http/http.dart' as http;


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

class FoodCentersMapPage extends StatefulWidget {
  const FoodCentersMapPage({Key key}) : super(key: key);

  @override
  _FoodCentersMapPageState createState() => _FoodCentersMapPageState();
}

class _FoodCentersMapPageState extends State<FoodCentersMapPage> {
  final _firebaseRef =
      FirebaseDatabase.instance.reference().child('CentroComida');

  GoogleMapController _controller;
  final user = FirebaseAuth.instance.currentUser;
  Set<Marker> _markers = Set<Marker>();
  List<FoodCenter> _centrosComida = [];
  double pinPillPosition = PIN_VISIBLE_POSITION;

  LatLng currentLocation = LatLng(-16.4994641047607, -68.12381440408689);
  LatLng destinationLocation = LatLng(-16.499513253747285, -68.12448863602962);

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylinesCoordinates = [];
  PolylinePoints polylinesPoints;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    polylinesPoints = PolylinePoints();
    setInitialLocation();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  void setInitialLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    showPinsOnMap();
  }

  void showPinsOnMap() async {
    await _firebaseRef.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      Icon icono;
      Color color;

      for (var key in keys) {

        _markers.add(
          Marker(
            markerId: MarkerId(values[key]['nombre']),
            position: LatLng(values[key]['latitud'], values[key]['longitud']),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: values[key]['nombre'],
              snippet: values[key]['direccion'],
            )
          ),
        );
        switch (values[key]['tipo']) {
          case 1:
            icono = Icon(FontAwesomeIcons.glassMartiniAlt);
            color = Colors.blueAccent;
            break;
          case 2:
            icono = Icon(FontAwesomeIcons.mugHot);
            color = Colors.red;
            break;
          case 3:
            icono = Icon(FontAwesomeIcons.hamburger);
            color = Colors.brown;
            break;
          case 4:
            icono = Icon(FontAwesomeIcons.iceCream);
            color = Colors.cyanAccent;
            break;
          case 5:
            icono = Icon(FontAwesomeIcons.utensils);
            color = Colors.orange;
            break;
          case 6:
            icono = Icon(FontAwesomeIcons.cookieBite);
            color = Colors.purpleAccent;
            break;
          default:
            icono = Icon(FontAwesomeIcons.cross);
            color = Colors.grey;
            break;
        }
        _centrosComida.add(FoodCenter(
            values[key]['nombre'],
            values[key]['numero'],
            values[key]['descripcion'],
            values[key]['horario'],
            values[key]['latitud'],
            values[key]['longitud'],
            values[key]['direccion'],
            values[key]['logo'],
            values[key]['banner'],
            values[key]['tipo'],
            double.parse(values[key]['rating'].toString()),
            color,
            icono, [], []));
      }
    });
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('SourcePin'),
          position: currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: currentLocation, zoom: 16, bearing: 90, tilt: 45)));
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

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_centrosComida[_pageController.page.toInt()].latitud,
            _centrosComida[_pageController.page.toInt()].longitud),
        zoom: 16,
        bearing: 90,
        tilt: 45)));
  }

  _foodCenterList(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin:
                        EdgeInsets.only(right: 25, bottom: 5, left: 25, top: 5),
                    height: 125.0,
                    width: 290.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset.zero,
                            blurRadius: 35.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.black45.withOpacity(0.0)),
                        child: Row(children: [
                          Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          _centrosComida[index].logo),
                                      fit: BoxFit.fill))),
                          Spacer(),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _centrosComida[index].nombre,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _centrosComida[index].descripcion,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _centrosComida[index].direccion,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  _centrosComida[index].numero,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ]),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ClipOval(
                                  child: Container(
                                    child: Icon(
                                      _centrosComida[index].icon.icon,
                                      size: 20,
                                      color: _centrosComida[index].color,
                                    ),
                                    color: Colors.black,
                                    padding: EdgeInsets.all(7),
                                  ),
                                ),
                              )
                            ],
                          )
                        ]))))
          ])),
    );
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
              myLocationButtonEnabled: true,
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
                  if (pinPillPosition == 10) {
                    pinPillPosition = -200;
                  } else {
                    pinPillPosition = 10;
                  }
                  // this.pinPillPosition = PIN_INVISIBLE_POSITION;
                });
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: currentLocation,
                        zoom: 16,
                        bearing: 90,
                        tilt: 55)));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        Text(
                          'Mi ubicacion',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
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
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _centrosComida.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _foodCenterList(index);
                  },
                ),
              ))
        ],
      ),
    );
  }
}
