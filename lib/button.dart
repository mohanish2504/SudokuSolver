import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getSolverButton(context) {
  return Ink(
    width: MediaQuery.of(context).size.width * 0.25,
    height: MediaQuery.of(context).size.height * 0.06,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(5)),
    child: Container(
        child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on_outlined,
            color: Colors.white,
            size: 25,
          ),
          SizedBox(width: 8,),
          Text('Solve',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    )),
  );
}

Widget getImportButton(context) {
  return Ink(
    width: MediaQuery.of(context).size.width * 0.25,
    height: MediaQuery.of(context).size.height * 0.06,
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(5)),
    child: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(width: 8,),
              Text('Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        )),
  );
}

Widget getButtonIcon() {
  return // Adobe XD layer: 'Icon material-grid-…' (shape)
      SvgPicture.string(
    '<svg viewBox="132.0 76.0 23.3 23.0" ><path transform="translate(129.04, 72.99)" d="M 23.93218231201172 3 L 5.325798034667969 3 C 4.046608924865723 3 3 4.035240650177002 3 5.300535202026367 L 3 23.70482063293457 C 3 24.97011375427246 4.046608924865723 26.00535583496094 5.325798034667969 26.00535583496094 L 23.93218231201172 26.00535583496094 C 25.21137046813965 26.00535583496094 26.25798034667969 24.97011375427246 26.25798034667969 23.70482063293457 L 26.25798034667969 5.300535202026367 C 26.25798034667969 4.035240650177002 25.21137046813965 3 23.93218231201172 3 Z M 9.977394104003906 23.70482063293457 L 5.325798034667969 23.70482063293457 L 5.325798034667969 19.1037483215332 L 9.977394104003906 19.1037483215332 L 9.977394104003906 23.70482063293457 Z M 9.977394104003906 16.80321311950684 L 5.325798034667969 16.80321311950684 L 5.325798034667969 12.2021427154541 L 9.977394104003906 12.2021427154541 L 9.977394104003906 16.80321311950684 Z M 9.977394104003906 9.901606559753418 L 5.325798034667969 9.901606559753418 L 5.325798034667969 5.300535202026367 L 9.977394104003906 5.300535202026367 L 9.977394104003906 9.901606559753418 Z M 16.95478820800781 23.70482063293457 L 12.30319213867188 23.70482063293457 L 12.30319213867188 19.1037483215332 L 16.95478820800781 19.1037483215332 L 16.95478820800781 23.70482063293457 Z M 16.95478820800781 16.80321311950684 L 12.30319213867188 16.80321311950684 L 12.30319213867188 12.2021427154541 L 16.95478820800781 12.2021427154541 L 16.95478820800781 16.80321311950684 Z M 16.95478820800781 9.901606559753418 L 12.30319213867188 9.901606559753418 L 12.30319213867188 5.300535202026367 L 16.95478820800781 5.300535202026367 L 16.95478820800781 9.901606559753418 Z M 23.93218231201172 23.70482063293457 L 19.28058624267578 23.70482063293457 L 19.28058624267578 19.1037483215332 L 23.93218231201172 19.1037483215332 L 23.93218231201172 23.70482063293457 Z M 23.93218231201172 16.80321311950684 L 19.28058624267578 16.80321311950684 L 19.28058624267578 12.2021427154541 L 23.93218231201172 12.2021427154541 L 23.93218231201172 16.80321311950684 Z M 23.93218231201172 9.901606559753418 L 19.28058624267578 9.901606559753418 L 19.28058624267578 5.300535202026367 L 23.93218231201172 5.300535202026367 L 23.93218231201172 9.901606559753418 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
    allowDrawingOutsideViewBox: true,
    fit: BoxFit.fill,
  );
}
