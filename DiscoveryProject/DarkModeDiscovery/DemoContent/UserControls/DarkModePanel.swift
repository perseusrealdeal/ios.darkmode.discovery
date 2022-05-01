//
//  OptionsPanel.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin on 15.02.2022.
//
//  Copyright © 2022 Mikhail Zhigulin. All rights reserved.
//

import UIKit

import PerseusDarkMode
import AdaptedSystemUI

class DarkModePanel: UIView
{
    // MARK: - Interface Builder connections
    
    @IBOutlet private weak var contentView     : UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    
    var segmentedControlValue: DarkModeOption = .auto { didSet { updateSegmentedControl() }}
    
    // MARK: - Closure for segmented control value changed event
    
    var segmentedControlValueChangedClosure: ((_ selected: DarkModeOption) -> Void)?
    
    // MARK: - Initiating
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commonInit()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
        configure()
    }
    
    // MARK: - Setup user control
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        
        addSubview(contentView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        contentView.autoresizingMask =
            [
                UIView.AutoresizingMask.flexibleLeftMargin,
                UIView.AutoresizingMask.flexibleRightMargin,
                UIView.AutoresizingMask.flexibleTopMargin,
                UIView.AutoresizingMask.flexibleBottomMargin
            ]
        
        // Dark Mode setup
        
        AppearanceService.register(observer: self, selector: #selector(makeUp))
        if AppearanceService.isEnabled { makeUp() }
    }
    
    // MARK: - Configure connected Interface Builder elements
    
    private func configure()
    {
        // Content border
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        // Segmented control
        
        updateSegmentedControl()
        segmentedControl?.addTarget(self,
                                    action: #selector(segmentedControlValueChanged(_:)),
                                    for: .valueChanged)
    }
    
    @objc private func makeUp()
    {
        segmentedControl?.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor._customSegmentedOneNormalText
            ], for: .normal)
        
        segmentedControl?.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor._customSegmentedOneSelectedText
            ], for: .selected)
    }
    
    private func updateSegmentedControl()
    {
        switch segmentedControlValue
        {
        case .auto:
            segmentedControl?.selectedSegmentIndex = 2
        case .on:
            segmentedControl?.selectedSegmentIndex = 1
        case .off:
            segmentedControl?.selectedSegmentIndex = 0
        }
    }
    
    // MARK: - Segmented control value changed event
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            segmentedControlValue = .off
        case 1:
            segmentedControlValue = .on
        case 2:
            segmentedControlValue = .auto
        default:
            return
        }
        
        segmentedControlValueChangedClosure?(segmentedControlValue)
    }
}
