import UIKit
import SwiftUI
import MapKit

class PlanRoutesMap: UIViewController, MKMapViewDelegate {
    
    private var mapView: MKMapView!
    
    // 출발지와 목적지의 위도, 경도, 이름을 저장하는 변수들
    var sourceLatitude: Double = 0
    var sourceLongitude: Double = 0
    var sourceName: String = ""
    var destinationLatitude: Double = 0
    var destinationLongitude: Double = 0
    var destinationName: String = ""
    
    // 추가된 UI 요소를 나타내는 레이블
    private let routeInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // 추가된 UI 요소를 나타내는 레이블 컨테이너
    private let infoContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        return containerView
    }()
    
    // 추가된 출발지 이름을 나타내는 레이블
    private let sourceNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 추가된 도착지 이름을 나타내는 레이블
    private let destinationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도의 원하는 크기를 지정
        let mapWidth: CGFloat = UIScreen.main.bounds.width
        let mapHeight: CGFloat = 672
        
        // MKMapView 초기화 및 뷰에 추가
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight))
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        // 출발지와 목적지에 마커 추가
        addMarker(at: CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude), name: sourceName)
        addMarker(at: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude), name: destinationName)
        
        // 출발지와 목적지의 중간 지점 계산
        let centerLatitude = (sourceLatitude + destinationLatitude) / 2
        let centerLongitude = (sourceLongitude + destinationLongitude) / 2
        
        // 중간 지점을 새로운 중심 좌표로 설정
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        mapView.setRegion(region, animated: true)
        
        infoContainerView.isHidden = true
        
        // 경로 찾기 및 지도에 표시
        findRoute(
            from: CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude),
            to: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        )
        
        // UI 요소를 뷰에 추가
        addUIElements()
    }
    
    // 마커 추가 함수
    func addMarker(at coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }
    
    // 출발지와 목적지 간 경로 찾기 함수
    func findRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 경로 표시
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            // 경로에 맞게 지도 확대
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), animated: true)
            
            // 경로의 길이와 걸리는 시간 표시
            self.displayRouteInformation(route)
            self.infoContainerView.isHidden = false
        }
    }
    
    // MKMapViewDelegate 메서드로 마커 뷰 커스터마이징
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    // MKMapViewDelegate 메서드로 경로 폴리라인 커스터마이징
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    // 경로의 길이와 걸리는 시간 표시 함수
    func displayRouteInformation(_ route: MKRoute) {
        let distance = route.distance // 미터 단위
        let expectedTravelTime = route.expectedTravelTime // 초 단위
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        let formattedDistance = distanceFormatter.string(fromDistance: distance)
        
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .positional
        timeFormatter.allowedUnits = [.minute]
        let formattedTime = timeFormatter.string(from: expectedTravelTime)
        
        let routeInfo = "\(formattedDistance)  /  \(formattedTime ?? "")분"
        
        routeInfoLabel.text = routeInfo
        sourceNameLabel.text = "\(sourceName)"
        destinationNameLabel.text = "\(destinationName)"
    }
    
    // 추가된 UI 요소를 뷰에 추가하는 함수
    private func addUIElements() {
        // UI 레이블과 레이블 컨테이너를 뷰에 추가
        mapView.addSubview(infoContainerView)
        infoContainerView.addSubview(routeInfoLabel)
        infoContainerView.addSubview(sourceNameLabel)
        infoContainerView.addSubview(destinationNameLabel)
        
        // 화살표 아이콘 추가
        let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right.circle.fill"))
        arrowImageView.tintColor = .red
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.addSubview(arrowImageView)
        
        // UI 레이블의 레이아웃 제약 설정
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        routeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        routeInfoLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        sourceNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        sourceNameLabel.textColor = UIColor(Color(hex: 0xF73E6C))
        destinationNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        destinationNameLabel.textColor = UIColor(Color(hex: 0xF73E6C))
        
        NSLayoutConstraint.activate([
            infoContainerView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -8),
            infoContainerView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 8),
            infoContainerView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            
            routeInfoLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 16),
            routeInfoLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            routeInfoLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            routeInfoLabel.bottomAnchor.constraint(equalTo: sourceNameLabel.topAnchor, constant: -40),
            
            sourceNameLabel.topAnchor.constraint(equalTo: routeInfoLabel.bottomAnchor, constant: 8),
            sourceNameLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            
            arrowImageView.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            
            destinationNameLabel.centerYAnchor.constraint(equalTo: sourceNameLabel.centerYAnchor),
            destinationNameLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            destinationNameLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: -16),
        ])
    }
}
