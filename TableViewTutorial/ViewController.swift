



import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    
    struct Cake {
        var name = String()
        var size = String()
    }
    
    var cakes = [Cake(name: "Red Velvet", size: "Small"),
                 Cake(name: "Brownie", size: "Medium"),
                 Cake(name: "Bannna Bread", size: "Large"),
                 Cake(name: "Vanilla", size: "Small"),
                 Cake(name: "Minty", size: "Medium")]
    
    var filteredCakes = [Cake]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredCakes = cakes
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Small", "Medium", "Large"]
        searchController.searchBar.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func applySearch(searchText: String, scope: String = "All") {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredCakes = cakes.filter { cake in
                let cakeSize = (scope == "All") || (cake.size == scope)
                return cakeSize
            }
        } else {
            // Filter the results based on the selected filer and search text
            filteredCakes = cakes.filter { cake in
                let cakeSize = (scope == "All") || (cake.size == scope)
                return cakeSize && cake.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //applySearch(searchText: searchController.searchBar.text!)
        let searchBar = searchController.searchBar
        let selectedScope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        applySearch(searchText: searchController.searchBar.text!,scope: selectedScope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        applySearch(searchText: searchController.searchBar.text!,scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredCakes[indexPath.row].name
        cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].size
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }

}

