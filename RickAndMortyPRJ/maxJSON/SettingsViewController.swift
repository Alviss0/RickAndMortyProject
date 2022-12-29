import UIKit

class SettingsViewController: UIViewController {
    


    var buttons = [UIButton]()
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    var lastButton: UIButton!

    
    let aliveKey = "alive"
    let deadKey = "dead"
    let unknownKey = "unknown"
    
    let keys = ["alive", "dead", "unknown"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttons.append(btn1)
        buttons.append(btn2)
        buttons.append(btn3)
        
        lastButton = btn1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       // print(lastButton.tag)
        
        setCollectionSetting(tag: lastButton.tag)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setCollectionSetting(tag: Int){
        
        UserDefaults.standard.set(keys[tag-1], forKey: "searchParam")
    }
    
    
    @IBAction func radioButtonClick(_ sender: UIButton) {
        
        setButtonActive(button:sender)
        lastButton = sender
    }
    
 
    
    func setButtonActive(button: UIButton){
        setButtonsDisable()
        setButtonSelected(button: button)
    }
  
    func setButtonSelected(button: UIButton){
        button.setBackgroundImage((UIImage(named: "selected")), for: .normal)
    }
    
    func setButtonsDisable(){
        for button in buttons{
            button.setBackgroundImage((UIImage(named: "unselected")), for: .normal)
        }
    }
}
