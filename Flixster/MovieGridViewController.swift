//
//  MovieGridViewController.swift
//  Flixster
//
//  Created by Yash Kakodkar on 2/4/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
        collectionView.layer.cornerRadius = 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2-4)/2
        layout.itemSize = CGSize(width: width, height: width*1.98)
        
        //Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.collectionView.reloadData()
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        
        let movie = movies[indexPath.item]
        let title = movie["title"] as! String
        let release = movie["release_date"] as! String
        //let year = release.prefix(4)
        
        cell.titleLabel.text = title
        cell.yearLabel.text = String(release.prefix(4))
        
        let base = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: base + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("loading data")
        
         // Find the selected movie
         let cell = sender as! UICollectionViewCell
         let indexPath = collectionView.indexPath(for: cell)!
         let movie = movies[indexPath.item]
         let detailsViewController = segue.destination as! MovieDetailsViewController
         detailsViewController.movie = movie
    
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
    

}
