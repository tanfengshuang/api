# robotframework
## Prepare robotframework test environment
### Install robotframework
```
pip install robotframework
```

### Install selenium2library
```
pip install robotframework-selenium2library
```

Refrence: 
http://robotframework.org/

http://robotframework.org/robotframework/

### Run test
```
Run one test case via name
# robot --test <case_name> <file_name.robot>

Run test via tag
# robot --include <tag_name> <file_name.robot>

Run all test cases of one robot file
# robot <file_name.robot>

Run all robot files in one directory
# robot <dir_name>/
```
## Install RobotFramework-EclipseIDE
https://github.com/NitorCreations/RobotFramework-EclipseIDE/wiki/Installation

https://github.com/NitorCreations/RobotFramework-EclipseIDE/wiki/Usage

## Prepare Google Chrome environment
### Install Google Chrome
```
[google64]
name=Google – x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub

yum install google-chrome-stable --nogpg   # To install the stable version
yum install google-chrome-unstable --nogpg # To install the lastest version
```
### Download Google Chrome Driver
https://sites.google.com/a/chromium.org/chromedriver/downloads

### Specify the path of ChromeDriver, you can finish it via the following 2 methods:
1. Config ChromeDriver to $PATH environment variable
```
echo $PATH
/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/home/ftan/.local/bin:/home/ftan/bin:/usr/src/googleChromeDriver
```
2. Via webdriver.chrome.driver system atrribute
