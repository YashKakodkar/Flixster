//
//  MoviesViewController.swift
//  Flixster
//
//  Created by Yash Kakodkar on 1/28/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.tableView.reloadData()
                print(dataDictionary)
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //table cell collection color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(displayP3Red: 0.15, green: 0.17, blue: 0.20, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        //image shadow
        cell.posterView.layer.shadowColor = UIColor.black.cgColor
        cell.posterView.layer.shadowOpacity = 0.8
        cell.posterView.layer.shadowOffset = CGSize.zero
        cell.posterView.layer.shadowRadius = 5
        cell.posterView.layer.shadowPath = UIBezierPath(rect: cell.posterView.layer.bounds).cgPath
        cell.posterView.layer.shouldRasterize = true
        
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        cell.titleLabel.text = title
        if(synopsis.count==0){
            cell.synopsisLabel.text = "No synopsis available."
        } else{
            cell.synopsisLabel.text = synopsis
        }
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
