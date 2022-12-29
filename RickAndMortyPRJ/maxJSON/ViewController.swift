
import UIKit

extension UIImageView {
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

struct Parent: Decodable{
    let results: [Person]
}

struct Person: Decodable {
    let name: String
    let image: String
}

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var characters = [Person]()
    
    var filteredCharacters = [Person]()
    
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.searchBar.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.dataSource = self
        
        var urlString = "https://rickandmortyapi.com/api/character/?status=alive"
        
        if let param = UserDefaults.standard.string(forKey: "searchParam"){
            urlString = "https://rickandmortyapi.com/api/character/?status=\(param)"
        }
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            
            do{
                let persons = try JSONDecoder().decode(Parent.self, from:data)
                self.characters = persons.results
                
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
            
            }.resume()
        
    }
    
    func urlBilder(){
        
        let baseURL = "https://rickandmortyapi.com/api/character/"
        
        
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredCharacters.count
        }else{
            return characters.count
        }
        
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        if isSearching {
            cell.nameLbl.text = filteredCharacters[indexPath.row].name.capitalized

            cell.imageView.downloaded(from: filteredCharacters[indexPath.row].image)
            
        }else{
            cell.nameLbl.text = characters[indexPath.row].name.capitalized
            
            cell.imageView.downloaded(from: characters[indexPath.row].image)
        }
        
        
        cell.layer.cornerRadius = 15

        cell.clipsToBounds = true
        cell.imageView.contentMode = .scaleAspectFill
  
        return cell
    }
   
    func scrollViewDidEndDragging(){}


}


extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredCharacters.removeAll()
        
        guard searchText != "" || searchText != " " else {
            print("bad search")
            return
        }
        
        for item in characters {
            let text = searchText.lowercased();
            
            let isArrayContain = item.name.lowercased().range(of: text)
            
            if isArrayContain != nil{
                filteredCharacters.append(item)
            }
        }
        
        print(filteredCharacters)
        
        if searchBar.text == "" {
            
            isSearching = false
            self.collectionView.reloadData()
            
        }else{
            isSearching = true
            
            filteredCharacters = characters.filter({$0.name.lowercased().contains(searchBar.text?.lowercased() ?? "")})
            
            self.collectionView.reloadData()
        }
        
    }
    
}






















