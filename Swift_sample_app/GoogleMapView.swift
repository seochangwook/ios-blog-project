//
//  GoogleMapView.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 28..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

class GoogleMapView : UIViewController, GMSMapViewDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //구글맵 설정//
        let camera = GMSCameraPosition.camera(withLatitude: 37.4836862,
                                              longitude:126.8742653, zoom:10)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        mapView.delegate = self
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "롯데정보통신"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}
