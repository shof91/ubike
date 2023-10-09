//
//  ViewController.swift
//  ubike
//
//  Created by sho on 2023/10/6.
//

import UIKit
import MapKit
class CustomTableViewCell: UITableViewCell {

    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let font = UIFont(name: "Arial", size: 10.0 )
        label1 = UILabel()
        label2 = UILabel()
        label3 = UILabel()
        label1.font = font
        label2.font = font
        label3.font = font
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label1.frame = CGRect(x: 23, y: 10, width: contentView.frame.width - 20, height: 20)
        label2.frame = CGRect(x: 75, y: 10, width: contentView.frame.width - 20, height: 20)
        label3.frame = CGRect(x: 153, y: 10, width: 120, height: 20)
    }
    
}
class ViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    struct BikeStation: Decodable {
        let sno: String
        let sna: String
        let tot: Int
        let sbi: Int
        let sarea: String
        let mday: String
        let lat: Double
        let lng: Double
        let ar: String
        let sareaen: String
        let snaen: String
        let aren: String
        let bemp: Int
        let act: String
        let srcUpdateTime: String
        let updateTime: String
        let infoTime: String
        let infoDate: String
    }
    
    var allStations = [BikeStation]()
    var filteredStations = [BikeStation]()
    var space1="      "
    var space2="      "
    var space3="             "
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "搜尋站點"
        searchBar.searchTextField.textColor = UIColor.init(red: 182.0/255.0, green: 204.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        navigationController?.delegate = self
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let BarItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = BarItem
        
        let imgBarItem = UIBarButtonItem(image: UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = imgBarItem
        
        
        let session = URLSession.shared
        let url = URL(string: "https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json")!


        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let jsonData = data else { return }
            //print("DATA1:\(jsonData)")
            do {
                let stations = try JSONDecoder().decode([BikeStation].self, from: jsonData)
                // 將資料存入 array 中，並更新 UI
                //print("DATA3:\(stations[2].sarea)")
                self.allStations = stations
                self.filteredStations = stations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        })

        task.resume()
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width-40, height: 40))
        //print("\(tableView.bounds.origin.x)")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: Int(headerView.frame.width), height: Int(headerView.frame.height)))
        headerText.text = "縣市  區域\(space2) 站點名稱"
        headerText.font = UIFont(name: "Arial", size: 20.0 )
        headerText.backgroundColor = .clear
        headerText.textColor = .white
        headerView.addSubview(headerText)
        headerView.backgroundColor = UIColor.init(red: 182.0/255.0, green: 204.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        //headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        tableView.tableHeaderView = headerView
        tableView.frame.size.width = self.view.bounds.width-40
        tableView.frame.size.height = self.view.frame.height-250
        tableView.clipsToBounds = true;
        tableView.layer.cornerRadius = 15;
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredStations.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let station = filteredStations[indexPath.row]
        let currentLocation = MKMapItem.forCurrentLocation()
        let longitude = station.lng
        let latitude = station.lat

      
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: location)
        let destinationLocation = MKMapItem(placemark: placemark)
        destinationLocation.name = station.sna

        MKMapItem.openMaps(with: [currentLocation, destinationLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CustomTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomTableViewCell

        if cell == nil {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        let station = filteredStations[indexPath.row]
        cell!.label1.text = "台北市"
        cell!.label2.text = "\(station.sarea)"
        cell!.label3.text = "\(station.sna)"


        //cell.addSubview(cellLabel)
        //cell.detailTextLabel?.text = "(\(station.lat), \(station.lng))"
        //let path = Bundle.main.path(forResource: "meun", ofType: "png")
        //cell.imageView?.image = UIImage(named: "menu")
        
        switch indexPath.row  % 2 {
            case 0:
            cell?.backgroundColor = .clear
            case 1:
            cell?.backgroundColor = .lightGray
             default:
                 break
         }

        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func menuButtonTapped() {
        // Handle left menu button tap
        //self.performSegue(withIdentifier: "goToView2", sender: nil)
        let myStoryBoard = UIStoryboard(name:"Main", bundle: nil)
        
              
        let targetController = myStoryBoard.instantiateViewController(withIdentifier: "menuViewController")
        targetController.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(targetController, animated: true)
    }

    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStations = allStations
        } else {
            filteredStations = allStations.filter { (station) -> Bool in
                return station.sna.contains(searchText) || station.ar.contains(searchText)
            }
        }
        
        tableView.reloadData()
    }
}
