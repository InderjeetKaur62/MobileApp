import UIKit

class ViewController:UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberTextField: UITextField!
    
    var timesTable: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func calculateTimesTable(_ sender: UIButton) {
        guard let text = numberTextField.text, let number = Int(text) else { return }
        timesTable = (1...10).map { $0 * number }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return timesTable.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(indexPath.row + 1) x \(numberTextField.text!) = \(timesTable[indexPath.row])"
            return cell
        }
    
    


}

