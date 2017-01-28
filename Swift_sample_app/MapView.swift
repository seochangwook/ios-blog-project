//
//  MapView.swift
//  Swift_sample_app
//
//  Created by apple on 2017. 1. 23..
//  Copyright © 2017년 apple. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import GoogleMaps //구글맵 관련 라이브러리. 최근 스위프트 버전 업데이트로 브릿징 헤더가 필요 없음//
import CoreLocation //지오코딩을 위해 필요한 라이브러리//
import AddressBookUI //지오코딩을 위해 필요한 라이브러리//

class MapView : SlideMenuController, GMSMapViewDelegate{
    var location_name : String = ""
    
    //위도와 경도값을 초기화//
    var search_address_latitude:CLLocationDegrees = 0.0
    var search_address_longitude:CLLocationDegrees = 0.0
    var original_address_latitude:CLLocationDegrees = 0.0
    var original_address_longitude:CLLocationDegrees = 0.0
    
    var mapView:GMSMapView? = nil //구글맵 뷰 객체//
    
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var search_input_location: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SlideMenuOptions.contentViewScale = 0.50
        SlideMenuOptions.hideStatusBar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        CLGeocoder().geocodeAddressString(location_name, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                //위도와 경도를 얻는다.//
                self.original_address_latitude = coordinate!.latitude
                self.original_address_longitude = coordinate!.longitude
                
                print("location name : ", self.location_name)
                self.location_label.text = self.location_name
                
                //구글맵 설정//
                let camera = GMSCameraPosition.camera(withLatitude: self.original_address_latitude,
                                                      longitude:self.original_address_longitude, zoom:16)
                //add a map as a subview, CGRectMake로 직접 뷰의 크기를 설정해준다.//
                self.mapView = GMSMapView.map(withFrame: self.CGRectMake(0, 59, 320, 211), camera:camera)
                
                //이벤트 등록//
                self.mapView?.delegate = self
                
                //지도의 유형을 변경가능//
                self.mapView?.mapType = kGMSTypeNormal //기본 유형으로 설정//
                
                //실내지도 on/off설정//
                self.mapView?.isIndoorEnabled = false
                
                //나의 위치정보 설정(GPS상황에 따라 환경이 달라질 수 있다.)//
                self.mapView?.isMyLocationEnabled = true
                
                if let mylocation = self.mapView?.myLocation {
                    print("User's location: \(mylocation)")
                } else {
                    print("User's location is unknown")
                }
                
                //지도 마커//
                let marker = GMSMarker()
                marker.position = camera.target
                marker.snippet = self.location_name
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = self.mapView
                
                /*********************************/
                
                //스트리트 뷰 설정//
                let panoView = GMSPanoramaView(frame: self.CGRectMake(0, 303, 320, 204))
                
                panoView.camera = GMSPanoramaCamera.init(heading:180, pitch: -10, zoom: 1) //스트리트 뷰의 POV설정//
                panoView.moveNearCoordinate(CLLocationCoordinate2DMake(37.4836862, 126.8742653))
                
                //스트리트 뷰 마커 설정//
                let position = CLLocationCoordinate2DMake(37.4836862, 126.8742653)
                let marker_streetview = GMSMarker(position: position)
                
                // Add the marker to a GMSPanoramaView object named panoView
                marker_streetview.panoramaView = panoView
                
                // Add the marker to a GMSMapView object named mapView
                marker_streetview.map = self.mapView
                
                /*********************************/
                
                //나의 위치정보 알기 버튼//
                self.mapView?.settings.compassButton = true
                self.mapView?.settings.myLocationButton = true
                
                /*********************************/
                
                self.view.addSubview(self.mapView!) //현재 뷰에 서브뷰를 등록//
                self.view.addSubview(panoView) //현재 뷰에 서브뷰를 등록//
                
                if (placemark?.areasOfInterest?.count)! > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    @IBAction func move_location_button(_ sender: UIButton) {
        print("move location")
        
        search_location(address: search_input_location.text!) //지오코딩을 이용해서 위도와 경도값을 추출(비동기 방식)//
    }
    
    func search_location(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                //위도와 경도를 얻는다.//
                self.search_address_latitude = coordinate!.latitude
                self.search_address_longitude = coordinate!.longitude
                
                //검색된 위도와 경도로 카메라 뷰를 다시 설정한다.//
                let location_info = GMSCameraPosition.camera(withLatitude: self.search_address_latitude,
                                                             longitude: self.search_address_longitude, zoom: 14)
                
                let fancy = GMSCameraPosition.camera(withLatitude: -33,
                                                     longitude: 151, zoom: 6, bearing: 30, viewingAngle: 45)
                self.mapView?.camera = fancy
                
                self.mapView?.camera = location_info
                
                //해당 이동된 위치에 마커찍기//
                //지도 마커//
                let marker = GMSMarker()
                marker.position = location_info.target
                marker.snippet = address
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = self.mapView
                
                //폴리라인 추가//
                let path = GMSMutablePath()
                
                path.addLatitude(37.4836862, longitude:126.8742653)
                path.addLatitude(self.search_address_latitude, longitude:self.search_address_longitude)
                
                let polyline = GMSPolyline(path: path)
                
                polyline.strokeWidth = 10.0
                polyline.geodesic = true
                polyline.map = self.mapView
                
                if (placemark?.areasOfInterest?.count)! > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    //GoogleMap 관련 이벤트//
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    //현재 위치하고 있는 뷰를 변경(Slide적용)//
    override func awakeFromNib() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier :"Right"){
            self.rightViewController = viewController
        }
        
        super.awakeFromNib()
    }
    
    @IBAction func slide_open_button(_ sender: UIBarButtonItem) {
        //현재 화면 상태에 따른 판단 후 액션 수행//
        if(self.slideMenuController()?.isRightOpen())!{
            self.slideMenuController()?.closeRight()
        }
        
        else{
            self.slideMenuController()?.openRight()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //빈 공간을 눌렀을때 키보드가 종료되는 것. 오버라이드해서 사용한다.//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        search_input_location.resignFirstResponder()
    }
}
