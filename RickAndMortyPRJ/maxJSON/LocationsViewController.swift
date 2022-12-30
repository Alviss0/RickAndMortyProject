import UIKit

/*extension UIImageView {
   func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
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
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
*/
    
struct ParentLocation: Decodable{
    let results: [Location]
}

struct Location: Decodable {
    let name: String
    let dimension: String
}


class LocationsViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.dataSource = self
        
        var urlString = "https://rickandmortyapi.com/api/location"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            
            do{
                let Location = try JSONDecoder().decode(ParentLocation.self, from:data)
                self.locations = Location.results
                
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
            
            }.resume()
        
    }

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return locations.count
    
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationsCell", for: indexPath) as! LocationsCollectionViewCell
    
    cell.dimensionLabel.text = locations[indexPath.row].dimension.capitalized
    cell.nameLabel.text = locations[indexPath.row].name.capitalized

    cell.layer.cornerRadius = 15

    cell.clipsToBounds = true


    return cell


}
    
}
