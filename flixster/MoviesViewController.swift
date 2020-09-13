//
//  MoviesViewController.swift
//  flixster
//
//  Created by Maaz Adil on 8/30/20.
//  Copyright © 2020 Maaz Adil (CodePath). All rights reserved.
//

import UIKit
import AlamofireImage
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //declare array and dictionary

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        //print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            
            self.movies = dataDictionary["results"] as! [[String:Any]] //gets movies array as results that are of type Strings and format is Any

            self.tableView.reloadData() //reload the API dictionary after startup
                print(dataDictionary)

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count  // returns number of rows by counting elements in movies array
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell  //Use next cell when screen is filled
            
            let movie = movies[indexPath.row] //gets movie from array of movies at row index
            let title = movie["title"] as! String //title is taken from movie dictionary format of string
            let synopsis = movie["overview"] as! String //synopsis is taken from movie dictionary in format of string
            
            cell.titleLabel.text = title
            cell.synopsisLabel.text = synopsis
            
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            //gets image size from imdb
            let posterPath = movie["poster_path"] as! String
            //posterPath from movie list as string
            let posterUrl = URL(string: baseUrl + posterPath)
            
            cell.posterView.af_setImage(withURL: posterUrl!) //gets url and downlloads and sets the image of movie
            
            return cell
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        //Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for:cell)!
        let movie = movies[indexPath.row]
        //Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   

}
