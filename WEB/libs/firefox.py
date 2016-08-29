#coding=utf-8
from selenium import webdriver
import time

print "ssss"

driver = webdriver.Firefox()

driver.get("http://www.baidu.com")

driver.get("http://m.mail.10086.cn")

#参数数字为像素点
print "设置浏览器宽 480、高 800 显示"
driver.set_window_size(480, 800)

time.sleep(5)

driver.quit()
