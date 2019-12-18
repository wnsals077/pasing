//
//  ViewController.swift
//  201880090 고준민
//
//  Created by D7703_15 on 2019. 12. 18..
//  Copyright © 2019년 BlueScreen. All rights reserved.
//


import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, XMLParserDelegate {
    @IBOutlet weak var MapView: MKMapView!
    var myaddressData = [addressData]()
    //
    var dlat = ""
    var dlng = ""
    var dtitle = ""
    var currentElement = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var pin = [MKAnnotation]()
        if let path = Bundle.main.url(forResource: "data1", withExtension: "xml") {
            //print(path)
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self

                if parser.parse() {
                    print("parse succeed!")
                    for i in 0..<myaddressData.count {
                        let pins = MKPointAnnotation()
                        pins.coordinate.latitude = Double(myaddressData[i].lat)!
                        pins.coordinate.longitude = Double(myaddressData[i].lng)!
                        pins.title = myaddressData[i].title
                        //mapView.addAnnotation(pin4)
                        pin.append(pins)   //배열 pins에 pins 넣기
                    }
                    MapView.showAnnotations(pin, animated: true)
                } else {
                    print("parse failed!")
                }
            }
        } else {
            print("xml file not found")
        }
    }
    
    // XMLParseDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    //2. tag 다음에 문자열을 만날때 실행
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 공백 등 제거
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch currentElement {
            case "lat" : dlat = data
            case "lng" : dlng = data
            case "title" : dtitle = data
            default : break
            }
        }
    }
    
    //3. tag가 끝날때 실행(/tag)
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = addressData()
            myItem.lat = dlat
            myItem.lng = dlng
            myItem.title = dtitle
            myaddressData.append(myItem)
        }
    }
}
