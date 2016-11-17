//
//  GameSettingTabView.swift
//  Swift_sample_app
//
//  Created by apple on 2016. 10. 29..
//  Copyright © 2016년 apple. All rights reserved.
//

import Foundation
import UIKit

class GameSettingTabView : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    //CollectionView에 들어갈 아이템(데이터), 네트워크나 데이터베이스로 가져올 수 있다.//
    var tableData : [String] = ["game1", "game2", "game3", "game4","game5", "game6", "game7", "game8"]
    var tableImage : [String] = ["cell_image_1.png", "cell_image_2.png", "cell_image_3.png", "cell_image_1.png",
                                 "cell_image_1.png", "cell_image_2.png", "cell_image_3.png", "cell_image_1.png"]
    var difficulr_image : [String] = ["easy_image.png", "normal_image.png", "hard_image.png"]
    
    var info_str : String = "게임 설정 탭"
    var layout_setting : UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var info_str_textfield: UILabel!
    
    @IBAction func back_button(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("tab3 view")
        
        info_str_textfield.text = self.info_str
        
        //CollectionView의 레이아웃 커스텀//
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        collectionViewLayout?.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //게임 설정 적용 버튼(게임 탭에 배지를 달아준다.)//
    @IBAction func adjust_gameset_button(_ sender: UIButton) {
        print("setting game option and badge")
        
        for item in self.tabBarController!.tabBar.items!
        {
            //게임하기 탭에 뱃지를 만들기 위해 플래그 설정//
            if item.tag == 1
            {
                item.badgeValue = "Adjust"
            }
        }
    }
    
    //CollectionView관련 메소드(스토리보드에서 datasource와 delegate를 메인 uiviewcontroller에다가 연결)//
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 //섹션 수 분할//
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) //첫번쨰 섹션에 대한 것//
        {
            return tableData.count
        }
        
        else
        {
            return difficulr_image.count
        }
    }
    
    //데이터 설정 메소드(TableView랑 유사하다.)//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //섹션으로 구분//
        if(indexPath.section == 0)
        {
            let cell : CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
            cell.collectioncell_textview.text = tableData[indexPath.row]
            cell.collectioncell_imageview.image = UIImage(named: tableImage[indexPath.row])
        
            return cell
        }
            
        else
        {
            let cell : CustomCollectionViewCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CustomCollectionViewCell2
            
            cell.image_cell2.image = UIImage(named: difficulr_image[indexPath.row])
            
            return cell
        }
    }
    
    //셀 아이템 클릭 리스너//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    //HeaderView, FooterView//
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header : CollectionViewHeader?
        
        if kind == UICollectionElementKindSectionHeader
        {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headercell", for: indexPath) as? CollectionViewHeader
            
            //indexPath의 Section을 가지고 구분//
            if(indexPath.section == 0)
            {
                header?.header_image.image = UIImage(named:"colheader_image.png")
                header?.header_label.text = "게임 샘플 이미지"
            }
            
            else
            {
                header?.header_image.image = UIImage(named:"celheader2_image.png")
                header?.header_label.text = "게임 난이도 설정"
            }
        }
        
        return header!
    }
}
