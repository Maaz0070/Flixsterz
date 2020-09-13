//
//  MovieGridViewController.swift
//  flixster
//
//  Created by Maaz Adil on 9/9/20.
//  Copyright © 2020 Maaz Adil (CodePath). All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
        
        
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 4
    let width = (view.frame.size.width - layout.minimumInteritemSpacing*1)/2
    layout.itemSize = CGSize(width: width, height: width*3/2)
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
               let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
               let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
               let task = session.dataTask(with: request) { (data, response, error) in
                  // This will run when the network request returns
                  if let error = error {
                     print(error.localizedDescription)
                  } else if let data = data {
                     let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    
                   self.movies = dataDictionary["results"] as! [[String:Any]] //gets movies array as results that are of type Strings and format is Any
                    self.collectionView.reloadData()
                    //after getting data from internet hey collection view reload your data because the movie count has been updated
                    print(self.movies)
                    
                    // print(dataDictionary) //prints the title of movies
                    // TODO: Get the array of movies
                      // TODO: Store the movies in a property to use elsewhere
                      // TODO: Reload your table view data

                    
                    
                  }
               }
               task.resume()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item] //Gets the movies, collectionViews have items
        
                   let baseUrl = "https://image.tmdb.org/t/p/w185" //gets image size from imdb
                   let posterPath = movie["poster_path"] as! String //posterPath from movie list as string
                   let posterUrl = URL(string: baseUrl + posterPath)
                   
                   cell.posterView.af_setImage(withURL: posterUrl!) //gets url and downlloads and sets the image of movie
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
