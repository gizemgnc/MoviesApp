//
//  MainTableViewController.swift
//  MoviesApp
//
//  Created by Gizem Genc on 12.09.2019.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainTableViewController: UITableViewController {
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
      
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        
        
          // Image
        if let imageURL = URL(string: movies[indexPath.row].image){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.movieImage.image = image
                    }
                }
            }
            }

            cell.ratingLabel.text = String("Rating : \(movies[indexPath.row].rating)")
            cell.releaseYearLabel.text = String(movies[indexPath.row].releaseYear)
            //cell.genreLabel.text = movies[indexPath.row].genre
            cell.titleLabel.text = movies[indexPath.row].title
            cell.genreLabel.text = ""

        return cell
    }
    
    
    func getData(){
        
        Alamofire.request("https://api.androidhive.info/json/movies.json", method: .get).validate().responseJSON { response in
            //print("gelen data \(response)")
            
            switch response.result {
            case .success(let value):
                
                  let json = JSON(value)
                 // print("json \(json)")
                for index in 0...json.count{
                    
                    let newMovie = Movie(title: json[index]["title"].stringValue,
                                         image: json[index]["image"].stringValue,
                                         rating: json[index]["rating"].doubleValue,
                                         releaseYear: json[index]["releaseYear"].intValue)
                    
                    self.movies.append(newMovie)
                }
              
               
               self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }


  

}
