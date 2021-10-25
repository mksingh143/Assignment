//
//  ViewController.swift
//  ManojiOSDev
//
//  Created by manojnkumar on 21/10/21.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var isMapSelected = false
    var truckResult: [TruckResult]? = nil
    var searchTruckResult: [TruckResult]? = nil
    var isSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.isHidden = true
        self.mapButton.image = UIImage.init(named: "map")

        self.callSearchTruckApiMethod()
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        self.searchTruck()
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        if self.isSearched {
            self.isSearched = false
            self.listTableView.reloadData()
        }
    }

    @IBAction func mapButtonAction(_ sender: Any) {
        self.isSearched = false
        if !self.isMapSelected {
            self.listTableView.isHidden = true
            self.mapView.isHidden = false
            self.isMapSelected = true
            self.mapButton.image = UIImage.init(named: "list")
            self.loadMap()
        }else {
            self.listTableView.isHidden = false
            self.mapView.isHidden = true
            self.isMapSelected = false
            self.mapButton.image = UIImage.init(named: "map")
        }
        self.listTableView.reloadData()
    }
        
}

// MARK:- Helper methods
extension ViewController {
    
    func loadMap() {

        if self.truckResult?.count ?? 0 > 0 {
            
            let camera = GMSCameraPosition.camera(withLatitude: (self.truckResult?[0].lastWaypoint?.lat)!, longitude: (self.truckResult?[0].lastWaypoint?.lng)!, zoom: 7.0)
            
            self.mapView.camera = camera
            
            for item in self.truckResult! {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: (item.lastWaypoint?.lat)!, longitude: (item.lastWaypoint?.lng)!)
                marker.title = ""
                marker.snippet = item.truckNumber
                if item.lastRunningState?.truckRunningState == 0 {
                    marker.icon = UIImage.init(named: "truckB")
                }else if item.lastRunningState?.truckRunningState == 1 {
                    marker.icon = UIImage.init(named: "truckG")
                }else {
                    marker.icon = UIImage.init(named: "truckR")
                }
                marker.map = mapView

            }
        }

    }
    
    // Search truck
    func searchTruck() {
        
//        /1. Create the alert controller.
        let alert = UIAlertController(title: "Search truck", message: "Enter truck number", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.isSearched = true
            self.searchTruckResult = self.truckResult?.filter({$0.truckNumber?.caseInsensitiveCompare((textField?.text)!) == .orderedSame})
//            print("Text field: \(textField?.text ?? "")")
            
            self.listTableView.isHidden = false
            self.mapView.isHidden = true
            self.isMapSelected = false
            self.listTableView.reloadData()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
        
    // Webservice method
    func callSearchTruckApiMethod() {
      // Set up the URL request
      let endpoint: String = "https://api.mystral.in/tt/mobile/logistics/searchTrucks?auth-company=PCH&companyId=33&deactivated=false&key=g2qb5jvucg7j8skpu5q7ria0mu&q-expand=true&q-include=lastRunningState,lastWaypoint"
      guard let url = URL(string: endpoint) else {
        print("Error: cannot create URL")
        return
      }
      let urlRequest = URLRequest(url: url)

      // set up the session
      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)

      // make the request
      let task = session.dataTask(with: urlRequest) {
        (data, response, error) in
        // check for any errors
        print(response!)

        guard error == nil else {
          print("error calling GET on search truck")
          print(error!)
          return
        }
        // make sure we got data
        guard let responseData = data else {
          print("Error: did not receive data")
          return
        }
        
        var truckData: TrucksModel? = nil
        do {
            truckData = try JSONDecoder().decode(TrucksModel.self, from: responseData)
            if truckData?.responseCode?.responseCode == 200 {
                self.truckResult = truckData?.data
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        } catch {
            print("\(error.localizedDescription)")
        }
      }
      task.resume()
    }

}

// MARK:- UITableViewDataSource methods
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearched ? (self.searchTruckResult?.count ?? 0) : (self.truckResult?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrucksTableViewCell") as? TrucksTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(truck: self.isSearched ? (self.searchTruckResult?[indexPath.row])! : (self.truckResult?[indexPath.row])!)

        return cell
    }
    
}
