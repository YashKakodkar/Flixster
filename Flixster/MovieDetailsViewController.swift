//
//  MovieDetailsViewController.swift
//  Flixster
//
//  Created by Yash Kakodkar on 1/31/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import WebKit
import ChameleonFramework
import AlamofireImage

class MovieDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var castTitle: UILabel!
    @IBOutlet weak var directorTitle: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backDropView: UIImageView!
    @IBOutlet weak var colorBackground: UIView!
    @IBOutlet weak var relatedCollectionGrid: UICollectionView!
    
    var movie: [String:Any]!
    var relatedMovies = [[String : Any]]()
    var cast = [[String : Any]]()
    var crew = [[String : Any]]()
    var videos = [[String : Any]]()
    var creditsLoaded = false
    var infoLoaded = false
    var relatedLoaded = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie["title"]!)
        //castLabel.text = ""
        //directorLabel.text = ""
        
        

        loadRelatedMovieData()
        loadData()
        loadCastDirector()
        while(!(creditsLoaded&&relatedLoaded&&infoLoaded)){
            loadVisuals()
            break;
        }
        
        self.relatedCollectionGrid.reloadData()
        print("items \(relatedCollectionGrid.numberOfItems(inSection: 0))")
        
        //self.navigationController!.navigationBar.backgroundColor = UIColor.clear
        
        
        
    }
    
    //function that enhances UI styling and aesthetic
    func loadVisuals() {
        print("visualTrue")
        
        //poster & shadow
        poster.layer.shadowColor = UIColor.black.cgColor
        poster.layer.shadowOpacity = 0.8
        poster.layer.shadowOffset = CGSize.zero
        poster.layer.shadowRadius = 5
        poster.layer.shadowPath = UIBezierPath(rect: poster.layer.bounds).cgPath
        poster.layer.shouldRasterize = true
        
        //background color
        let backgroundColors: [UIColor] = ColorsFromImage(poster.image!, withFlatScheme: true)
        colorBackground.backgroundColor = backgroundColors[2]
        yearLabel.textColor = backgroundColors[1]
        if (getContrastColor(color: backgroundColors[2])){
            titleLabel.textColor = UIColor.black
            synopsisLabel.textColor = UIColor.black
            directorTitle.textColor = UIColor.black
            castTitle.textColor = UIColor.black
            directorLabel.textColor = UIColor.darkText
            castLabel.textColor = UIColor.darkText
        }
        
        
        
        //collection view ui
        relatedCollectionGrid.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        //relatedCollectionGrid.layer.cornerRadius = 2
        let layout = relatedCollectionGrid.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2-35)/3
        layout.itemSize = CGSize(width: width, height: width*1.5)
        
    }
    
    //loads up all movie information
    func loadData(){
        print("dataTrue")
        
        let release = movie["release_date"] as! String
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        yearLabel.text = String(release.prefix(4))
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        
        
        let baseURL = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        poster.af_setImage(withURL: posterURL!)
        
        //backdrop
        let backDropPath = movie["backdrop_path"] as! String
        let backDropURL = URL(string: "https://image.tmdb.org/t/p/w1280" + backDropPath)
        backDropView.af_setImage(withURL: backDropURL!)
        
        let image: UIImage? = poster.image
        if image != nil{
            self.infoLoaded = true
        }
        
    }
    
    //setups information for related movies
    func loadRelatedMovieData() {
        print("relatedTrue")
        relatedCollectionGrid.delegate = self
        relatedCollectionGrid.dataSource = self
        
        let movieID = movie["id"] as! Int
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let taskRelated = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.relatedMovies = dataDictionary["results"] as! [[String: Any]]
                print("relatedMovies: " + "\(self.relatedMovies.count)")
                self.relatedCollectionGrid.reloadData()
                self.relatedLoaded = true
            }
        }
        taskRelated.resume()
    }
    
    
    //sets up information for cast and director
    func loadCastDirector(){
        let movieID = movie["id"] as! Int
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        print(url)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let taskRelated = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.cast = dataDictionary["cast"] as! [[String: Any]]
                self.crew = dataDictionary["crew"] as! [[String: Any]]
  
                //create cast and director strings
                var castMembers = ""
                castMembers.append(self.cast[0]["name"] as! String)
                for i in 1...min(5,self.cast.count-1){
                    castMembers.append(", " + (self.cast[i]["name"] as! String))
                }
                let director = self.crew[0]["name"] as! String
                
                self.castLabel.text = castMembers
                self.directorLabel.text = director
                self.creditsLoaded = true
                
                
            }
        }
        taskRelated.resume()
        
    }
    
    
    func getContrastColor(color: UIColor) -> Bool {
        
        var r:CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, al:CGFloat = 0
        var red = 0
        var blue = 0
        var green = 0
        // Counting the perceptive luminance - human eye favors green color...
        if color.getRed(&r, green: &g, blue: &b, alpha: &al) {
            red = Int(r * 255.0)
            green = Int(g * 255.0)
            blue = Int(b * 255.0)
        }
        let rr = Double(red) * 0.299
        let gg = Double(green) * 0.587
        let bb = Double(blue) * 0.114
        let a = 1 - (rr+gg+bb) / 255;
        
        if (a < 0.5) {
            print(true)
            return true // bright colors - black font
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, relatedMovies.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = relatedCollectionGrid.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        print(relatedMovies.count)
        print(indexPath.item)
        let movie = relatedMovies[indexPath.item]
        
        let base = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: base + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        cell.posterView.layer.shadowColor = UIColor.black.cgColor
        cell.posterView.layer.shadowOpacity = 0.8
        cell.posterView.layer.shadowOffset = CGSize.zero
        cell.posterView.layer.shadowRadius = 5
        cell.posterView.layer.shadowPath = UIBezierPath(rect: cell.posterView.layer.bounds).cgPath
        cell.posterView.layer.shouldRasterize = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
        // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard
                let headerView = relatedCollectionGrid.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "\(DetailHeaderView.self)",
                    for: indexPath) as? DetailHeaderView
                else {
                    fatalError("Invalid view type")
            }
            
            
            //headerView.relatedLabel.text = "More like this"
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }
    
    

    
    // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("loading data")
        
         // Find the selected movie
         //if(segue.identifier=="similarSegue"){
            let cell = sender as! UICollectionViewCell
            let indexPath = relatedCollectionGrid.indexPath(for: cell)!
            let movie = relatedMovies[indexPath.item]
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
//         } else if(segue.identifier=="trailerToDetail"){
//            let trailerWebViewController = segue.destination as! trailerViewController
//        }
        
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }

}
