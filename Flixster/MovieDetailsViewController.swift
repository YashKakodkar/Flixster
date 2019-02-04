//
//  MovieDetailsViewController.swift
//  Flixster
//
//  Created by Yash Kakodkar on 1/31/19.
//  Copyright © 2019 Yash Kakodkar. All rights reserved.
//

import UIKit
import ChameleonFramework

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var backDropView: UIImageView!
    
    var movie: [String:Any]!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie["title"]!)
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        
        //poster & shadow
        posterView.layer.shadowColor = UIColor.black.cgColor
        posterView.layer.shadowOpacity = 0.8
        posterView.layer.shadowOffset = CGSize.zero
        posterView.layer.shadowRadius = 5
        posterView.layer.shadowPath = UIBezierPath(rect: posterView.layer.bounds).cgPath
        posterView.layer.shouldRasterize = true
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        posterView.af_setImage(withURL: posterURL!)
    
        
        //backdrop
        let backDropPath = movie["backdrop_path"] as! String
        let backDropURL = URL(string: "https://image.tmdb.org/t/p/w780" + backDropPath)
        backDropView.af_setImage(withURL: backDropURL!)
        
        let backgroundColors: [UIColor] = ColorsFromImage(posterView.image!, withFlatScheme: true)
        self.view.backgroundColor = backgroundColors[3]
        self.title = "Detail"
        if (getContrastColor(color: backgroundColors[3])){
            titleLabel.textColor = UIColor.black
            synopsisLabel.textColor = UIColor.black
        }
        //self.navigationController!.navigationBar.backgroundColor = UIColor.clear
        
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
