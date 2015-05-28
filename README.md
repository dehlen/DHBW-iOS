# DHBW iOS Client
This version is experimental and its possible that bugs will occur. Please report them with the help of the issue tracker and feel free to contribute to fix them :)

###Run

DHBW-iOS uses Cocoapods in order to create a dependency management for third-party libraries. 
To run the application from your Xcode Installation make sure to install cocoapods first via:
```sh
$  sudo gem install cocoapods
```

Then change to the project's base directoy, where the *Podfile* lies and run:
```sh
$  pod install
```

After that you should open the *.xcworkspace* file and not the *.xcodeproj*. This is important when working with cocoapods, in order to ensure that all third-party libraries are setup to run the project.


###License
© Copyright David Ehlen 2015
