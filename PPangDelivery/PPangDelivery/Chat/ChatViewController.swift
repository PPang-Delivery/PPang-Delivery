
import UIKit
import SnapKit


class ChatViewController: UIViewController{
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(40)
        }
        return tableView
    }()
    
    var dataSource = [CustomCellModel]()
    
    
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        loadData()
    }

    private func setup() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        dataSource.append(.init(leftImage: UIImage(systemName: "pencil")!, leftTitle: "연필"))
        dataSource.append(.init(leftImage: UIImage(systemName: "bookmark.fill")!, leftTitle: "북마크"))
        tableView.reloadData()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell ?? CustomCell()
        cell.bind(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}
