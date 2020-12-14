//
//  DetailsVC.swift
//  ScoutiumTest
//
//  Created by Eyüp YASUNTİMUR on 13.12.2020.
//

import UIKit

// for loading image from an url
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
    

class DetailsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var swipeDownLabel: UILabel!
    
    var item: JsonStats?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        swipeDownLabel.isHidden = true
        titleLabel.isHidden = true
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
            self.spinner.stopAnimating() // stops spinner
            self.spinner.hidesWhenStopped = true // hides spinner
            self.imageView.isHidden = false
            self.swipeDownLabel.isHidden = false
            self.titleLabel.isHidden = false
        })
        titleLabel.text = item?.title
        let urlString = "https://storage.googleapis.com/anvato-sample-dataset-nl-au-s1/life-1/"+(item?.url)!
        let url = URL(string: urlString)
        imageView.downloaded(from: url!)
    }
    
}
