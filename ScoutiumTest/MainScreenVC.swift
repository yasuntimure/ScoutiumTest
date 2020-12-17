 
 
 //
 //  MainScreenVC.swift
 //  ScoutiumTest
 //
 //  Created by Eyüp YASUNTİMUR on 10.12.2020.
 //

 import UIKit

 class MainScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

     @IBOutlet weak var spinner: UIActivityIndicatorView! // Loading Variable
     @IBOutlet weak var tableView: UITableView!
     
    // JsonStats is a struct for loading JSON Data
     var item: JsonStats?
     var jsonStats = [JsonStats]()
    
     override func viewDidLoad() {
         super.viewDidLoad()
         tableView.delegate = self
         tableView.dataSource = self
         tableView.isHidden = true // hides tableView while spinner works
         spinner.startAnimating() // starts spinner
        // Starts downloadJSON functions and loads the JSON data
         downloadJSON {
           self.tableView.reloadData()
          }
         
        
         // Makes 3 Seconds delay for spinner animation
         DispatchQueue.main.asyncAfter(deadline:.now() + 3.0, execute: {
             self.spinner.stopAnimating() // stops spinner
             self.spinner.hidesWhenStopped = true // hides spinner
             self.tableView.isHidden = false // shows tableView
         })
     }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonStats.count // count of variable in Json Data "items"
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell // reference the CustomTableViewCell
        cell.titleLabel.text = jsonStats[indexPath.row].title.capitalized // loads the title string data from JsonStats struct
        cell.cellView.layer.cornerRadius = 10
        var urlData = jsonStats[indexPath.row].url
        urlData = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/" + urlData
        let url = URL(string: urlData)
        cell.logoImage.downloaded(from: url!)
        cell.logoImage.layer.cornerRadius = 10
        cell.logoImage.contentMode = UIView.ContentMode.scaleAspectFill;
        cell.logoImage.layer.masksToBounds = true
        return cell
        }
    
    
    
    
    func downloadJSON(completed : @escaping () -> ()){
        let url = URL(string: "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/data.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
         
             // ensures there is no error for this HTTP response
             guard error == nil else {
                print ("error: \(error!)")
                return
             }
             
             // ensures there is data returned from this HTTP response
             guard let data = data else {
               print("No data")
               return
             }
             
             // Parses JSON into Dictionary that contains Array of  struct using JSONDecoder
             guard let itemDict = try? JSONDecoder().decode([String: [JsonStats]].self, from: data) else {
               print("Error: Couldn't decode data into dictionary of array of items")
               return
             }
            
             // gets the key is "items"
             self.jsonStats = itemDict["items"]!
             
             // to see the data on the console
             for item in self.jsonStats {
               print("item tite : \(item.title)")
               print("item url : \(item.url)")
               print("---")
             }
         }
         // execute the HTTP request
         task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailsVC", sender: self)
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsVC {
            destination.item = jsonStats[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
}
     


 
 
 
 
 
 
 
 
 
 
 
 
 
 
