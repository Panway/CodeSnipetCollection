# Panda Developer Kit



## iOS

所有库均是子pod，所有类均采用PP前缀，只是为了能快速打出来
``` bash
#快捷AlertView和AlertAction (Block封装)
pod 'PPiOSKit/PPAlertAction', :git=>'https://github.com/Panway/CodeSnipetCollection.git'

#0行代码实现右滑pop返回
pod 'PPiOSKit/SwipePopGesture', :git=>'https://github.com/Panway/CodeSnipetCollection.git'

#0行代码捕获常见数组字典异常，防止闪退
pod 'PPiOSKit/CrashCatcher', :git=>'https://github.com/Panway/CodeSnipetCollection.git'

# 支付宝SDK镜像,适用于集成了百川sdk，出现UTDID冲突
pod 'AlipayiOSSDK',:git => 'https://github.com/wooodypan/AlipaySDKMirror.git'

# 腾讯开放平台
pod 'QQSDK',:git =>'https://github.com/wooodypan/QQSDK.git'
```

## Git
```bash
#一行代码创建git忽略文件（如需忽略Pods文件夹请vim .gitignore修改）
curl https://raw.githubusercontent.com/github/gitignore/master/Objective-C.gitignore -o .gitignore
```

