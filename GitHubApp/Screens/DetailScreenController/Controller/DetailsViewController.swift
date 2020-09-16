//
//  DetailsViewController.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//



import UIKit


// Итак у нас 2 View которые нужно заполнить данными!


class DetailsViewController : UIViewController {
  
  
  
  
  //MARK: - Properties
  private var detailViewModel  : DetailScreenViewModel
  
  // Outlets

  private lazy var headerView = DetailHeaderView(frame: .init(x: 0, y: 0, width: 0, height: 200))
  
  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.dataSource = self
    tableView.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.cellId)
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
    
    return tableView
  }()
  
  
  
  
  
  // Data
  private var repos       : [Repository] = []
  
  
  // MARK: - Init
  
  init(detailViewModel : DetailScreenViewModel) {
    self.detailViewModel = detailViewModel
    super.init(nibName: nil, bundle: nil)
    
  }
  
  
  // MARK: - Lyfe Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addTableView()
    
    // Запускаем загрузку данных для нашего экрана!
    // Можно это вообще сделать на этапе инициализации!
    // попробую разные варианты
    fetchDataToScreen()
   
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "Details Screen"
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addTableView() {
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.tableHeaderView = headerView
  }
  

  
}
// MARK: - Fetch Data to Screen
extension DetailsViewController {
  
  private func fetchDataToScreen() {
    detailViewModel.fetchDetailScreenData { [weak self]  (result) in
         guard let self = self else { return }
         
         switch result {
         case .failure(let error):
           print("Detail Data Fetch Error",error)
         case .success(let detailScreenModel):
           print("Succes")
           
           self.headerView.configure(viewModel: detailScreenModel.details)
           self.repos = detailScreenModel.repos ?? []
           self.tableView.reloadData()
         }
         
       }
  }
}

// MARK: TableView Delegate and DataSource
extension DetailsViewController: UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RepoListCell.cellId, for: indexPath) as! RepoListCell
    cell.configure(viewModel: repos[indexPath.row])
    setCellSignals(cell)
    return cell
  }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repos.count
  }
}

// MARK: Cell Signals
extension DetailsViewController {
  
  func setCellSignals(_ cell: RepoListCell) {
    cell.didTapMoreButtonClouser = {[weak self] button in
      
      guard
        let indexPath = self?.tableView.indexPath(for: cell)
      else {return}
      
      self?.repos[indexPath.row].isNeedMoreInfo.toggle()
      self?.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
}
