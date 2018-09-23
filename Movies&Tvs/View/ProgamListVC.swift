//
//  ViewController.swift
//  Movies&Tvs
//
//  Created by Jesus on 9/21/18.
//  Copyright © 2018 Jesus Paraada. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyHelpers
import SwiftSpinner

struct ProgramListSection {
    var header: String
    var items: [Item]
}

extension ProgramListSection: SectionModelType {
    typealias Item = Program
    
    init(original: ProgramListSection, items: [Item]) {
        self = original
        self.items =  items
    }
}

class ProgamListVC: UIViewController {

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.placeholder = "Search movie or tv show"
        }
    }
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var progamCollectionView: UICollectionView!{
        didSet {
            progamCollectionView.showsVerticalScrollIndicator = false
            progamCollectionView <= ProgramListCell.self
        }
    }
    
    private var disposeBag = DisposeBag()
    private var viewModel: ProgramsViewModel = ProgramsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func rxBind() {
        SwiftSpinner.show("Loading movies ...")
        self.viewModel.getMovieList(by: ProgramType.popularMovies)
            .retry(3)
            .subscribe({ [weak self] event in
                switch event {
                case let .next(response):
                    self?.viewModel.programs = response
                    self?.viewModel.rx_ProgramList.value = response
                case .error:
                    SwiftSpinner.hide()
                    self?.showOfflineAlert()
                case .completed:
                    SwiftSpinner.hide()
                }
            }).disposed(by: disposeBag)
        
        let dataSource = createDataSource()
        
        self.viewModel.rx_ProgramList.asObservable()
            .map(self.viewModel.setMovies)
            .bind(to: self.progamCollectionView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
        
        self.progamCollectionView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
//        self.progamCollectionView.rx
//            .modelSelected(Program.self)
//            .subscribe(onNext: { [unowned self] taxi in
//                self.showMap(for: taxi)
//            }).disposed(by: self.disposeBag)
        
    }

    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ProgramListSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProgramListSection>(configureCell:{ (dataSource: CollectionViewSectionedDataSource<ProgramListSection>, collectionView: UICollectionView, indexPath: IndexPath, item: Program) in
            let cell: ProgramListCell = collectionView.cellForClass(indexPath)
            cell.buildCell(for: item)
            return cell
        })
        return dataSource
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProgamListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.contentSize.width, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5.0, left: 0, bottom:5.0 , right:0)
    }
}

// MARK: - Alerts
extension ProgamListVC {
    
    func showOfflineAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("You are offline", comment: "You are offline"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        if let navigation = self.navigationController?.visibleViewController {
            if !(navigation.isKind(of: UIAlertController.self)) {
                OperationQueue.main.addOperation {
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
