//
//  HomeVC.swift
//  UtilityConverter-iOS
//
//  Created by Gautham Sritharan on 2021-02-14.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var homeCollectionView: UICollectionView! {
        didSet {
            homeCollectionView.dataSource = self
            homeCollectionView.delegate = self
        }
    }
    
    // MARK: - Variables
    
    private let bag = DisposeBag()
    let vm = HomeVM()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        vm.getConversionType()
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.007843137255, green: 0.08235294118, blue: 0.1568627451, alpha: 1)
        
        backgroundView.applyGradient(isTopBottom: true, colorArray: UIColor.GradientColor.HomeView)
    }
}

// MARK: - Extensions

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.arrHomeCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCVCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        cell.configCell(model: vm.arrHomeCollectionView[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            let ViewController = UIStoryboard.init(name: "Conversion", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeightVC") as? WeightVC
            self.navigationController?.pushViewController(ViewController!, animated: true)
        case 1:
            let ViewController = UIStoryboard.init(name: "Conversion", bundle: Bundle.main).instantiateViewController(withIdentifier: "TemperatureVC") as? TemperatureVC
            self.navigationController?.pushViewController(ViewController!, animated: true)
        case 2:
            let ViewController = UIStoryboard.init(name: "Conversion", bundle: Bundle.main).instantiateViewController(withIdentifier: "LengthVC") as? LengthVC
            self.navigationController?.pushViewController(ViewController!, animated: true)
        case 3:
            let ViewController = UIStoryboard.init(name: "Conversion", bundle: Bundle.main).instantiateViewController(withIdentifier: "SpeedVC") as? SpeedVC
            self.navigationController?.pushViewController(ViewController!, animated: true)
        case 4:
            let ViewController = UIStoryboard.init(name: "Conversion", bundle: Bundle.main).instantiateViewController(withIdentifier: "VolumeLiquidVC") as? VolumeLiquidVC
            self.navigationController?.pushViewController(ViewController!, animated: true)
        default:
            break
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 10
        let height = width/2
        
        return CGSize(width: width, height: height)
    }
}
