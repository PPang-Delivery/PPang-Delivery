//
//  CustomCell.swift
//  PPangDelivery
//
//  Created by 지상률 on 2022/10/12.
//

import Foundation
import UIKit
import SnapKit

//CustomCell 추가

class CustomCell: UITableViewCell {
    static let identifier = "CustomCell" //타입 메서드, CustomCell.identifier로 접근 가능
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [leftImageView, leftLabel, rightButton])
        contentView.addSubview(stackView) //superView대신에 contentView를 이용한 이유는 UITableViewCell에 이유가있다.
        
        stackView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(contentView)
            //autolayout이 모든 방향이 모둑 같다는 의미는 0이라는 뜻이다.
            //그래서 contentView에 꽉 채워지게 된다.
        }
        return stackView
    }()
    
    lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "star.fill")!
        imageView.image = image
        imageView.setContentHuggingPriority(.required, for: .horizontal)// 최대 크기에 대한 저항
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal) //최소 크기에 다한 저항
        imageView.snp.makeConstraints{(make) in
            make.width.equalTo(40)
        }
        return imageView
    }()
    
    lazy var leftLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    //초기화 코드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print(stackView)
                                 }
    
    required init(coder: NSCoder) {
        fatalError("init(coder: )has not been impl")
    }
}

extension CustomCell {
    public func bind(model: CustomCellModel) {
        leftImageView.image = model.leftImage
        leftLabel.text = model.leftTitle
    }
}
