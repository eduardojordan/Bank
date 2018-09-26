//
//  ViewController.swift
//  BankBank
//
//  Created by Eduardo on 26/9/18.
//  Copyright © 2018 Eduardo Jordan Muñoz. All rights reserved.
//

import UIKit

struct jsonStuct: Decodable {
    let date: String?
    let description: String?
    let amount: Double?
    let fee: String?

}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var tableView: UITableView!
    
var arrData = [jsonStuct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getData()
        
    }
    
    func getData(){
        let url = URL (string: "https://api.myjson.com/bins/1a30k8")
         URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {if error == nil{
                self.arrData = try JSONDecoder().decode([jsonStuct].self, from: data!)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                
                for mainArr in self.arrData{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                  }
                }
            }catch{
                print("Error in get json data", error)
            }
            
        }.resume()
    }
    
// TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
      
        cell.descriptionLabel.text = "Description : \(arrData[indexPath.row].description)"
        cell.dateLabel.text = "Date : \(arrData[indexPath.row].date)"
        cell.amountLabel.text = "Amount : \(arrData[indexPath.row].amount)"
        
        return  cell
    }
}

// Nota : Intente realizarlo con cocoaPods Alamofire, pero consegui problemas al encontrar que el array del api no tienen nombre. Entonces intente realizarlo aprovechando las ventajas de swift 4 y json, pero me da problemas al momento de representarlo en el tableView, imagino que debe ser debido primero al formato de fecha el cual debo cambiar para solucionarlo

// Dejo pendiente los calculos de comisiones con referencia al total

// El cambio de color cuando son egresos e ingresos, asi como el orden descendente segun las fechas
