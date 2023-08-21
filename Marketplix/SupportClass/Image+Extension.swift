//
//  Image+Extension.swift
//  Marketplix
//
//  Created by Kiran P M on 14/08/23.
//

import UIKit

extension UIImage{
    
    static var checkBox : UIImage {return UIImage(named: "checkbox-check") ?? UIImage()}
    static var un_checkBox : UIImage {return UIImage(named: "checkbox-unchecked") ?? UIImage()}

}

extension UIImage {
  convenience init?(url: String?) {
    guard let url = url else { return nil }
            
    do {
        self.init(data: try Data(contentsOf: URL(string: url)!))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
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
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
