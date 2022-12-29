import UIKit

class LoadViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createTimer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func createTimer(){
        var isOpen = false
        
        var count = 0
        
        let newVC = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        _=Timer.scheduledTimer(withTimeInterval:0.8, repeats: true){
            [weak self] timer in
            if count >= 3{
                timer.invalidate()
                
               
                self?.navigationController?.pushViewController(newVC, animated: true)
                
//                self?.present(newVC, animated: false, completion: nil)
            }
            
            count += 1
            
            if(isOpen){
                isOpen = false
                
                DispatchQueue.main.async {
                    self?.Image.image = UIImage(named:"left")
                    UIView.transition(with: (self?.Image)!, duration: 0.8, options: .transitionFlipFromRight, animations: nil, completion: nil)
                }
            }else{
                isOpen = true
                
                DispatchQueue.main.async {
                    self?.Image.image = UIImage(named:"right")
                    UIView.transition(with: (self?.Image)!, duration: 0.8, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                }
            }
        }
    }

}
