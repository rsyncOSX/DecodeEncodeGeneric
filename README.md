## Hi there 👋

This package is generic code for decode and encode JSON data, as part of reading and writing data to local storage. Data are tasks, logrecords and user configuration.

The package is used in [version 2.1.1 and later](https://github.com/rsyncOSX/RsyncUI) of RsyncUI.

By Using Swift Package Manager (SPM), parts of the source code in RsyncUI is extraced and created as packages. The old code, the base for packages, is deleted and RsyncUI imports the new packages.  

In Xcode 16 there is also a new module, Swift Testing, for testing packages.By SPM and Swift Testing, the code for RsyncUI is modularized, isolated, and tested before committing changes.

