# CycleScrollView-Swift
自定义静态图片轮播，可以通过左右滑动或者点击两端使其滚动，通过设置 tapHandle 获取点击中间图片的 index（从0开始）

## ScreenShot

![image](https://github.com/Xiaoye220/Demos/blob/master/CycleScrollView/YFCycleScrollView-Swift/ScreenShot/ScreenShot.gif)
## How to use
```Swift
//imageNamed
let array = ["0","1","2","3","4","5"]
let cycleScrollView = YFCycleScrollView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 200), imageNamed: array)

cycleScrollView.pageControlTintColor = UIColor.black
cycleScrollView.pageControlCurrentPageTintColor = UIColor.lightGray
cycleScrollView.timeInterval = 2
cycleScrollView.tapHandle = { [weak self] index in
    self?.reslutLabel.text = "currentIndex:" + String(index)
}

view.addSubview(cycleScrollView)
```
## Interface

```Swift
public protocol YFCycleScrollViewInterface : class {

    var timeInterval: TimeInterval { get set }

    var tapHandle: ((_ index: Int) -> Void)? { get set }

    var pageControlTintColor: UIColor? { get set }

    var pageControlCurrentPageTintColor: UIColor? { get set }

    init(frame: CGRect, imageNamed: [String])

}
```

